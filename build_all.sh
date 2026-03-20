#!/usr/bin/env bash
# =============================================================================
#  wb-crop-disease-detector — Full Build Pipeline
#
#  Usage:
#    bash build_all.sh                   Full pipeline (train + build APK)
#    bash build_all.sh --skip-train      Use placeholder model, build APK only
#    bash build_all.sh --train-only      Train + convert, skip APK
#    bash build_all.sh --help            Show this message
#
#  Requirements:
#    - Python 3.9+   with pip
#    - Flutter 3.10+ in PATH
#    - Android SDK   configured
#    - kaggle.json   at ~/.kaggle/kaggle.json  (for --skip-train omit this)
# =============================================================================

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ── Colours ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
BOLD='\033[1m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
info() { echo -e "${YELLOW}[→]${NC} $*"; }
die()  { echo -e "${RED}[✗] ERROR:${NC} $*" >&2; exit 1; }

# ── Argument parsing ──────────────────────────────────────────────────────────
SKIP_TRAIN=false
TRAIN_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --skip-train)  SKIP_TRAIN=true ;;
    --train-only)  TRAIN_ONLY=true ;;
    --help|-h)
      sed -n '3,15p' "$0" | sed 's/^#  \?//'
      exit 0 ;;
  esac
done

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   🌾  WB Crop Disease Detector — Build Pipeline  ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── Prerequisite checks ───────────────────────────────────────────────────────
info "Checking prerequisites…"
command -v python3 &>/dev/null || die "Python 3 not found. Install from python.org"

if [ "$SKIP_TRAIN" = false ] && [ "$TRAIN_ONLY" = false ] || [ "$TRAIN_ONLY" = true ]; then
  command -v flutter &>/dev/null || true   # checked later if needed
fi

if [ "$SKIP_TRAIN" = false ]; then
  [ -f "$HOME/.kaggle/kaggle.json" ] || \
    { info "~/.kaggle/kaggle.json not found — will try --skip-train fallback"; SKIP_TRAIN=true; }
fi

# ── Install Python deps ───────────────────────────────────────────────────────
info "Installing Python dependencies…"
pip3 install -r training/requirements.txt -q 2>/dev/null \
  || pip3 install -r training/requirements.txt -q --break-system-packages

# ─────────────────────────────────────────────────────────────────────────────
# ML PIPELINE
# ─────────────────────────────────────────────────────────────────────────────

MODEL_DEST="app/assets/model/model.tflite"

if [ "$SKIP_TRAIN" = true ]; then
  info "Skipping training — generating placeholder TFLite model…"
  python3 training/generate_placeholder_model.py
  log "Placeholder model created at $MODEL_DEST"
else
  # Step 1: Download & prepare
  info "Step 1/3 — Downloading and preparing dataset…"
  python3 training/01_download_and_prepare.py \
    || { info "Download failed — falling back to placeholder model"
         python3 training/generate_placeholder_model.py
         SKIP_TRAIN=true; }

  if [ "$SKIP_TRAIN" = false ]; then
    # Step 2: Train
    info "Step 2/3 — Training MobileNetV2 model…"
    info "          This may take 15–60 minutes depending on hardware."
    python3 training/02_train_model.py

    # Step 3: Convert to TFLite
    info "Step 3/3 — Converting to TFLite + quantising…"
    python3 training/03_convert_tflite.py
  fi
fi

# ── Verify model exists ───────────────────────────────────────────────────────
[ -f "$MODEL_DEST" ] || die "model.tflite not found at $MODEL_DEST"
MODEL_MB=$(du -h "$MODEL_DEST" | cut -f1)
log "Model ready: $MODEL_DEST  (${MODEL_MB})"

# ─────────────────────────────────────────────────────────────────────────────
# FLUTTER BUILD
# ─────────────────────────────────────────────────────────────────────────────

if [ "$TRAIN_ONLY" = true ]; then
  info "Skipping Flutter build (--train-only)"
else
  command -v flutter &>/dev/null || die "Flutter not found in PATH. See https://flutter.dev/docs/get-started/install"

  info "Getting Flutter packages…"
  cd app
  flutter pub get

  info "Running Flutter analysis…"
  flutter analyze --no-fatal-infos || true   # warn but don't abort

  info "Building release APK (split by ABI)…"
  flutter build apk --release --split-per-abi

  cd "$SCRIPT_DIR"

  # ── Collect APKs ───────────────────────────────────────────────────────────
  mkdir -p release_apks
  find app/build/app/outputs/flutter-apk/ -name "*.apk" \
    -exec cp {} release_apks/ \; 2>/dev/null || true

  echo ""
  echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${GREEN}║                 Build Complete! 🎉               ║${NC}"
  echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
  log "APKs saved to: $SCRIPT_DIR/release_apks/"
  echo ""
  ls -lh release_apks/*.apk 2>/dev/null || true
  echo ""
  echo -e "${BOLD}Install on connected device:${NC}"
  echo "  adb install release_apks/app-arm64-v8a-release.apk"
  echo ""
  echo -e "${BOLD}Next steps:${NC}"
  echo "  1. Test the APK on a real device"
  echo "  2. Replace the placeholder model with the trained one (if applicable)"
  echo "  3. Follow GITHUB_PUBLISHING_GUIDE.md to publish to GitHub"
  echo ""
fi

log "Done ✅"
