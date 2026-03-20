# GitHub Publishing Guide

## Complete step-by-step guide to publish wb-crop-disease-detector to GitHub

---

## Prerequisites

```bash
git --version       # Must be ≥ 2.30
gh --version        # GitHub CLI (optional but recommended)
# Install gh: https://cli.github.com
```

---

## Step 1 — Configure Git identity

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

---

## Step 2 — Initialise the repository locally

```bash
cd wb-crop-disease-detector

git init -b main
git add .
git status    # Review what will be committed
```

Expected output — confirm `.tflite` and `build/` are NOT listed:
```
On branch main
Changes to be committed:
  new file:   .gitignore
  new file:   .github/workflows/flutter_ci.yml
  new file:   .github/ISSUE_TEMPLATE/bug_report.md
  new file:   .github/ISSUE_TEMPLATE/feature_request.md
  new file:   CHANGELOG.md
  new file:   CONTRIBUTING.md
  new file:   LICENSE
  new file:   README.md
  new file:   app/lib/main.dart
  ... (all source files)
  new file:   dataset_info/README.md
  new file:   dataset_info/class_distribution.md
  new file:   model/README.md
  new file:   model/labels.txt
  new file:   training/*.py
  new file:   training/README.md
  new file:   training/requirements.txt
```

```bash
git commit -m "feat: initial public release — KrishakAI v1.0.0

- Flutter app with 5 screens (splash, language, onboarding, home, result)
- MobileNetV2 TFLite model for 15 crop disease classes
- Bengali, Hindi, English multilingual support
- 100% offline on-device inference
- Complete training pipeline (download, train, convert)
- GitHub Actions CI workflow
- Full documentation"
```

---

## Step 3 — Create the GitHub repository

### Option A — GitHub CLI (recommended)

```bash
gh auth login    # Follow the prompts to authenticate

gh repo create wb-crop-disease-detector \
  --public \
  --description "🌾 AI crop disease detection for West Bengal farmers — Flutter + TFLite + Bengali/Hindi/English" \
  --homepage "https://github.com/YOUR_USERNAME/wb-crop-disease-detector" \
  --push \
  --source .

# Add topics (helps discoverability):
gh repo edit wb-crop-disease-detector \
  --add-topic "flutter" \
  --add-topic "tensorflow-lite" \
  --add-topic "machine-learning" \
  --add-topic "android" \
  --add-topic "agriculture" \
  --add-topic "west-bengal" \
  --add-topic "crop-disease" \
  --add-topic "deep-learning" \
  --add-topic "mobilenetv2" \
  --add-topic "farmers"
```

### Option B — GitHub Web UI

1. Go to https://github.com/new
2. Set:
   - Repository name: `wb-crop-disease-detector`
   - Description: `🌾 AI crop disease detection for West Bengal farmers — Flutter + TFLite + Bengali/Hindi/English`
   - Visibility: **Public**
   - Initialize: **No** (leave all checkboxes unchecked — we have our own files)
3. Click **Create repository**
4. Then push:

```bash
git remote add origin https://github.com/YOUR_USERNAME/wb-crop-disease-detector.git
git push -u origin main
```

---

## Step 4 — Set up repository settings

On GitHub, go to **Settings** for your repo:

### About section (right sidebar)
- Description: `🌾 AI crop disease detection for West Bengal farmers`
- Website: _(leave blank or link to a demo page)_
- Topics: `flutter tensorflow-lite machine-learning android agriculture west-bengal crop-disease`

### Pages (optional — host the interactive guide)
- Source: `main` branch, `/docs` folder _(if you place HTML guide there)_

### Branch protection (recommended)
- **Settings → Branches → Add rule**
- Branch name pattern: `main`
- ☑ Require pull request reviews before merging
- ☑ Require status checks to pass (select `Flutter CI / Dart Analyze`)

---

## Step 5 — Build the release APK

```bash
# On your local machine with Flutter installed:
cd wb-crop-disease-detector/app

# Add the trained model (download from training pipeline or Releases):
cp ~/path/to/model.tflite assets/model/model.tflite

flutter pub get
flutter build apk --release --split-per-abi

# APK locations:
ls build/app/outputs/flutter-apk/
# app-arm64-v8a-release.apk     ← Modern phones (primary)
# app-armeabi-v7a-release.apk   ← Older phones
# app-x86_64-release.apk        ← Emulators
```

---

## Step 6 — Create a GitHub Release

### Option A — GitHub CLI

```bash
# Tag the release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Create release and upload all assets
gh release create v1.0.0 \
  --title "KrishakAI v1.0.0 — Initial Release" \
  --notes-file - << 'NOTES'
## 🌾 KrishakAI v1.0.0

First public release of the WB Crop Disease Detector.

### What's New
- Detect diseases in rice, wheat, corn, and potato leaves
- Works 100% offline — no internet required
- Bengali, Hindi, and English interface
- 15 disease classes with treatment recommendations

### Download & Install
1. Download `app-arm64-v8a-release.apk` below (for modern phones)
2. Transfer to your Android device
3. Enable "Install from unknown sources" in Settings
4. Open the APK and tap Install

> Requires Android 5.0 or higher.

### For Developers
- Download `model.tflite` and place it at `app/assets/model/model.tflite`
- Then `cd app && flutter pub get && flutter run`

### Known Limitations
- Model accuracy: ~85–92% (small training dataset of ~1,300 images)
- All current disease classes are fungal
- Low-confidence results (<50%) should be verified with a local agronomist
NOTES

# Upload APK and model
gh release upload v1.0.0 \
  app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk \
  app/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk \
  training/models/crop_disease_fp16.tflite#model.tflite
```

### Option B — GitHub Web UI

1. Go to **Repository → Releases → Draft a new release**
2. Tag: click **Choose a tag** → type `v1.0.0` → **Create new tag**
3. Title: `KrishakAI v1.0.0 — Initial Release`
4. Description: paste release notes (see above)
5. Attach files by dragging or clicking:
   - `app-arm64-v8a-release.apk`
   - `app-armeabi-v7a-release.apk`
   - `model.tflite` (from `training/models/crop_disease_fp16.tflite`)
6. Click **Publish release**

---

## Step 7 — Verify the release

```bash
# Check release was created:
gh release list

# Download and verify the APK:
gh release download v1.0.0 --pattern "*.apk" --dir /tmp/verify/
ls -lh /tmp/verify/

# Install on connected device:
adb install /tmp/verify/app-arm64-v8a-release.apk
```

---

## Ongoing workflow

```bash
# After making changes:
git add .
git commit -m "fix: correct Bengali translation for 'treatment'"
git push origin main

# For a new release:
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
gh release create v1.1.0 --generate-notes \
  app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## Repository health checklist

After publishing, verify:

- [ ] `README.md` renders correctly on GitHub (check images, badges)
- [ ] `.gitignore` excludes `build/`, `*.tflite`, `*.jks`
- [ ] GitHub Actions CI passes on `main`
- [ ] Release APK is downloadable from Releases page
- [ ] `model.tflite` is available as a release asset
- [ ] Repository topics are set for discoverability
- [ ] Issues are enabled (Settings → General → Features → Issues ✓)
- [ ] `CONTRIBUTING.md` is linked in README

---

## Discoverability tips

1. **Star your own repo** to give it an initial count
2. **Share on X/Twitter** with hashtags: `#Flutter #MachineLearning #AgriTech #WestBengal`
3. **Post on Reddit**: r/FlutterDev, r/MachineLearning, r/india
4. **Submit to** [awesome-flutter](https://github.com/Solido/awesome-flutter) via PR
5. **Write a blog post** on Dev.to or Medium — link back to the repo
6. **Share with** agricultural universities in West Bengal (BCKV, Bidhan Chandra Krishi Viswavidyalaya)
