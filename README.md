<div align="center">

# 🌾 WB Crop Disease Detector

### AI-powered crop disease detection for farmers in West Bengal, India

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![TensorFlow Lite](https://img.shields.io/badge/TensorFlow%20Lite-2.13+-FF6F00?logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![Android](https://img.shields.io/badge/Android-5.0%2B-3DDC84?logo=android&logoColor=white)](https://developer.android.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Languages](https://img.shields.io/badge/Languages-Bengali%20%7C%20Hindi%20%7C%20English-orange)](#multilingual-support)
[![Offline](https://img.shields.io/badge/Works-100%25%20Offline-brightgreen)](#offline-first)

**Detect rice, wheat, corn, and potato diseases from a single leaf photo — instantly, offline, in Bengali.**

[📥 Download APK](#-download--install) · [🚀 Build from Source](#-build-from-source) · [🧠 Train the Model](#-model-training) · [🤝 Contribute](#-contributing)

---

<!-- Replace the line below with actual screenshots once the APK is built -->
<img src="dataset_info/screenshots/app_flow.png" alt="KrishakAI App Screenshots" width="700"/>

*Screenshot placeholder — see [adding screenshots](#adding-screenshots) to contribute real device photos.*

</div>

---

## 📖 Table of Contents

- [About the Project](#-about-the-project)
- [Features](#-features)
- [Supported Diseases](#-supported-diseases)
- [App Screenshots](#-app-screenshots)
- [Model Details](#-model-details)
- [Dataset](#-dataset)
- [Download & Install](#-download--install)
- [Build from Source](#-build-from-source)
- [Model Training](#-model-training)
- [Project Structure](#-project-structure)
- [Multilingual Support](#-multilingual-support)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [License](#-license)
- [Acknowledgements](#-acknowledgements)

---

## 🌱 About the Project

West Bengal is home to over **7 million farming households**, the majority of whom grow rice, wheat, potato, and maize. Crop diseases can destroy up to **40% of a season's yield** — yet early detection and correct treatment can save most of it.

**WB Crop Disease Detector** puts an AI agronomist in every farmer's pocket:

- Take a photo of any diseased leaf
- Get an instant diagnosis — with the disease name, cause, symptoms, and treatment — in **Bengali, Hindi, or English**
- Works completely **offline**, so it functions in villages with no mobile data

The app is built with [Flutter](https://flutter.dev) and runs a [MobileNetV2](https://arxiv.org/abs/1801.04381) model optimised with [TensorFlow Lite](https://www.tensorflow.org/lite), achieving sub-400 ms inference on a mid-range Android phone.

---

## ✨ Features

| Feature | Details |
|---------|---------|
| 📷 **Camera capture** | Snap a leaf photo in-app |
| 🖼️ **Gallery upload** | Pick from existing photos |
| 🧠 **On-device AI** | MobileNetV2 + TFLite — no server, no internet |
| ✅ **15-class detection** | 4 crops × healthy + disease classes |
| 📊 **Confidence score** | Colour-coded bar: green ≥75%, amber ≥50%, red <50% |
| 💊 **Treatment advice** | India-specific fungicide/pesticide recommendations |
| 🛡️ **Prevention tips** | Season-appropriate prevention guidance |
| 🌐 **3 languages** | Bengali (default), Hindi, English |
| 📵 **Fully offline** | Works with zero internet after installation |
| 📤 **Share results** | Send diagnosis via WhatsApp/SMS |
| 🕓 **Top-3 predictions** | Shows alternative diagnoses with confidence |

---

## 🦠 Supported Diseases

<table>
<tr>
<th>🌾 Rice</th>
<th>🌿 Wheat</th>
<th>🌽 Corn</th>
<th>🥔 Potato</th>
</tr>
<tr>
<td>

- Brown Spot ⚠️
- Leaf Blast ⚠️
- Neck Blast ⚠️
- Healthy ✅

</td>
<td>

- Brown Rust ⚠️
- Yellow Rust ⚠️
- Loose Smut ⚡
- Healthy ✅

</td>
<td>

- Common Rust ⚡
- Gray Leaf Spot ⚡
- N. Leaf Blight ⚠️
- Healthy ✅

</td>
<td>

- Early Blight ⚡
- Late Blight ⚠️
- Healthy ✅

</td>
</tr>
</table>

⚠️ High severity · ⚡ Medium severity · ✅ Healthy

All disease entries include: **Bengali/Hindi/English name · Cause type · Symptoms · India-specific treatment · Prevention**

---

## 📱 App Screenshots

| Splash | Language | Home | Analyzing | Result |
|--------|----------|------|-----------|--------|
| ![Splash](dataset_info/screenshots/splash.png) | ![Language](dataset_info/screenshots/language.png) | ![Home](dataset_info/screenshots/home.png) | ![Analyzing](dataset_info/screenshots/analyzing.png) | ![Result](dataset_info/screenshots/result.png) |

> 📸 **Help us!** If you've built and tested the app, please [submit screenshots](#adding-screenshots) via a pull request.

---

## 🧠 Model Details

| Property | Value |
|----------|-------|
| **Architecture** | MobileNetV2 (ImageNet pre-trained) |
| **Input size** | 224 × 224 × 3 (RGB) |
| **Output** | 15-class softmax |
| **Format** | TensorFlow Lite (FP16 quantised) |
| **Model size** | ~8 MB (FP16) |
| **Inference time** | ~150–400 ms on CPU (ARM64) |
| **Expected accuracy** | 85–92% on test split |
| **Framework** | TensorFlow 2.13+ / Keras |

### Training Strategy

```
Phase 1  ──  Head only        epochs ≤ 60   LR = 1e-3   (base frozen)
Phase 2  ──  Fine-tune top 50  epochs ≤ 30   LR = 1e-5   (gradual unfreeze)
```

**Anti-overfitting measures** (critical with ~1,300 images):
- Random augmentation: flip · rotation ±25° · zoom ±20% · brightness ±20% · contrast ±20%
- Dropout: 50% after Dense(256), 30% after Dense(128)
- L2 regularisation (λ=1e-4) on all dense layers
- Early stopping (patience=10) on `val_accuracy`
- ReduceLROnPlateau (factor=0.5, patience=4)

---

## 📦 Dataset

| Property | Details |
|----------|---------|
| **Source** | [Kaggle — Top Agriculture Crop Disease](https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease) |
| **Author** | kamal01 |
| **Crops** | Rice, Wheat, Corn, Potato |
| **Total images** | ~1,300 labelled leaf photos |
| **Classes** | 15 (11 disease + 4 healthy) |
| **Split used** | 80% train / 10% val / 10% test |
| **Image size** | Resized to 224×224 |
| **Normalisation** | MobileNetV2 preprocess → [−1, 1] |

See [`dataset_info/README.md`](dataset_info/README.md) for full class breakdown and preprocessing details.

---

## 📥 Download & Install

### Option A — GitHub Releases (easiest)

1. Go to the [**Releases page**](../../releases/latest)
2. Download `app-release.apk`
3. Transfer the APK to your Android phone
4. On your phone: **Settings → Apps → Install unknown apps** → allow your file manager
5. Open the APK file and tap **Install**

> Requires Android 5.0 (API 21) or higher.

### Option B — ADB (USB install)

```bash
# Enable USB Debugging: Settings → Developer Options → USB Debugging
adb install app-release.apk
```

### Option C — QR code / wireless

Share the APK via WhatsApp, Google Drive, or Files by Google between devices.

---

## 🚀 Build from Source

### Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.10.0 | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥ 3.0.0 | Bundled with Flutter |
| Android SDK | API 21–34 | [Android Studio](https://developer.android.com/studio) |
| Java (JDK) | 11 or 17 | [Adoptium](https://adoptium.net) |

### 1 — Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/wb-crop-disease-detector.git
cd wb-crop-disease-detector
```

### 2 — Add the TFLite model

The trained `.tflite` model is distributed via [GitHub Releases](../../releases/latest) (not committed to the repo to keep it lightweight).

```bash
# Download the latest model from Releases, then:
cp ~/Downloads/model.tflite app/assets/model/model.tflite

# --- OR --- generate a placeholder for UI testing (no accurate predictions):
cd training
pip install tensorflow
python generate_placeholder_model.py
# This writes app/assets/model/model.tflite automatically
```

### 3 — Get Flutter packages

```bash
cd app
flutter pub get
```

### 4 — Run on a connected device

```bash
flutter run                        # Debug mode
flutter run --release              # Release mode (faster)
```

### 5 — Build APK

```bash
# Split APKs (smaller files, recommended)
flutter build apk --release --split-per-abi

# Universal APK (single file, works on all devices)
flutter build apk --release

# Output location:
# app/build/app/outputs/flutter-apk/
#   app-arm64-v8a-release.apk   ← Modern phones (use this)
#   app-armeabi-v7a-release.apk ← Older / 32-bit phones
#   app-x86_64-release.apk      ← Emulators
```

### Verify the build

```bash
flutter doctor            # Check for issues
flutter analyze           # Static analysis
flutter test              # Run tests (if any)
```

---

## 🧪 Model Training

You can reproduce the trained model from scratch using the scripts in `training/`.

### Prerequisites

```bash
cd training
pip install -r requirements.txt
```

Requires Python 3.9–3.11 and ~4 GB RAM (8 GB recommended for training).

### Step 1 — Download and prepare dataset

```bash
# Install Kaggle CLI and place your API key at ~/.kaggle/kaggle.json
pip install kaggle
python 01_download_and_prepare.py
```

This downloads the dataset, auto-discovers class folders, and creates `data/processed/splits/{train,val,test}/` with an 80/10/10 split.

```bash
# If you already have the dataset extracted:
python 01_download_and_prepare.py --skip-download
```

### Step 2 — Train the model

```bash
python 02_train_model.py
```

Training runs in two phases:
- **Phase 1** — classification head only (~60 epochs, LR=1e-3)
- **Phase 2** — fine-tune top 50 MobileNetV2 layers (~30 epochs, LR=1e-5)

Outputs saved to `training/logs/`:
- `training_report.png` — accuracy/loss curves + confusion matrix
- `classification_report.txt` — per-class precision, recall, F1
- `history_phase1.csv`, `history_phase2.csv` — raw metrics

### Step 3 — Convert to TFLite

```bash
python 03_convert_tflite.py
```

Produces three variants with benchmarks:
- `crop_disease_dynamic.tflite` — dynamic-range quantisation
- `crop_disease_fp16.tflite` — FP16 quantisation (~8 MB, **recommended**)
- `crop_disease_int8.tflite` — INT8 quantisation (smallest, requires calibration data)

The best model is automatically copied to `app/assets/model/model.tflite`.

### Step 4 — Rebuild the APK

```bash
cd ../app
flutter build apk --release --split-per-abi
```

### One-command full pipeline

```bash
# From the repo root:
bash training/build_all.sh
```

---

## 📁 Project Structure

```
wb-crop-disease-detector/
│
├── app/                              Flutter Android application
│   ├── lib/
│   │   ├── main.dart                 Entry point, theme, locale
│   │   ├── l10n/                     Localisation (EN / BN / HI)
│   │   │   ├── app_localizations.dart
│   │   │   ├── app_en.arb
│   │   │   ├── app_bn.arb
│   │   │   └── app_hi.arb
│   │   ├── models/
│   │   │   ├── disease_info.dart     15-class disease DB (3 languages)
│   │   │   └── prediction_result.dart
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── scan_result_screen.dart
│   │   │   └── language_screen.dart
│   │   ├── services/
│   │   │   ├── tflite_service.dart   On-device inference engine
│   │   │   └── app_state.dart        Language / locale provider
│   │   └── widgets/
│   │       ├── crop_card.dart
│   │       └── info_section.dart
│   ├── assets/model/
│   │   ├── model.tflite              ← Download from Releases
│   │   └── labels.txt                15 class names
│   ├── android/                      Native Android config
│   └── pubspec.yaml
│
├── model/
│   └── labels.txt                    Class label reference
│
├── training/                         ML pipeline (Python)
│   ├── 01_download_and_prepare.py    Kaggle download + 80/10/10 split
│   ├── 02_train_model.py             MobileNetV2 transfer learning
│   ├── 03_convert_tflite.py          FP16 / INT8 quantisation
│   ├── generate_placeholder_model.py Build test without training
│   └── requirements.txt
│
├── dataset_info/
│   ├── README.md                     Dataset details, class list
│   ├── class_distribution.md         Image counts per class
│   └── screenshots/                  App screenshots (contribute yours!)
│
├── .github/
│   ├── workflows/
│   │   └── flutter_ci.yml            CI: lint + build on every push
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
│
├── .gitignore
├── LICENSE
└── README.md                         ← You are here
```

---

## 🌐 Multilingual Support

The app ships with full UI translations in three languages. The default language on first launch is **Bengali** (most relevant for West Bengal users).

| Language | Code | Script | Completeness |
|----------|------|--------|-------------|
| Bengali  | `bn` | বাংলা  | 100% ✅ |
| Hindi    | `hi` | हिंदी  | 100% ✅ |
| English  | `en` | Latin  | 100% ✅ |

All disease information (symptoms, cause, treatment, prevention) is stored in all three languages inside `app/lib/models/disease_info.dart`.

To add a new language, create `app/lib/l10n/app_XX.arb` (copy from `app_en.arb`) and add the locale to `app/lib/main.dart`.

---

## 🤝 Contributing

Contributions of all kinds are welcome — especially from people with agricultural knowledge or experience building apps for Indian farmers.

### How to contribute

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/add-jute-diseases`
3. **Commit** your changes: `git commit -m "feat: add jute yellow mite disease class"`
4. **Push** the branch: `git push origin feature/add-jute-diseases`
5. **Open** a Pull Request

### Priority contributions

- 📸 **Screenshots** — real device photos of the app in action
- 🌿 **New disease classes** — jute, mustard, onion (common in WB)
- 🗣️ **Translation corrections** — native Bengali/Hindi speaker review
- 🧪 **More training images** — locally photographed Bengal crop photos
- 🐛 **Bug reports** — use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md)

### Adding screenshots

```bash
# Take screenshots on your device, then:
mkdir -p dataset_info/screenshots
cp splash.png language.png home.png analyzing.png result.png \
   dataset_info/screenshots/
git add dataset_info/screenshots/
git commit -m "docs: add real device screenshots"
git push
```

### Code style

- Dart: follow [Effective Dart](https://dart.dev/guides/language/effective-dart) conventions
- Python: PEP 8, type hints where practical
- All public functions must have a docstring / doc comment

---

## 🗺️ Roadmap

| Version | Planned Features |
|---------|-----------------|
| v1.1 | Add jute and mustard diseases |
| v1.2 | Voice output (read results aloud) |
| v1.3 | Weather integration — seasonal disease alerts |
| v2.0 | Crowdsourced image upload to improve model |
| v2.1 | WhatsApp chatbot interface |
| v2.2 | Marketplace — link to local pesticide suppliers |

---

## 🚀 Creating a GitHub Release

After building the APK, publish it so farmers can download it directly:

```bash
# 1. Tag the release
git tag -a v1.0.0 -m "Release v1.0.0 — initial public release"
git push origin v1.0.0

# 2. Via GitHub CLI (optional)
gh release create v1.0.0 \
  --title "KrishakAI v1.0.0" \
  --notes "First public release. Supports rice, wheat, corn, potato." \
  app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk \
  model/model.tflite
```

Or via the GitHub web UI:
1. **Repository → Releases → Draft a new release**
2. Tag: `v1.0.0`, Title: `KrishakAI v1.0.0`
3. Attach files: `app-arm64-v8a-release.apk`, `model.tflite`
4. Click **Publish release**

---

## 📞 Agricultural Support (West Bengal)

| Resource | Contact |
|----------|---------|
| 🌾 Kisan Call Centre | **1800-180-1551** (toll-free, 24×7) |
| 🏛️ WB Agriculture Dept | [matirkatha.net](https://matirkatha.net) |
| 🔬 Krishi Vigyan Kendra | Contact your district KVK office |
| 📱 mKisan Portal | [mkisan.gov.in](https://mkisan.gov.in) |

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

> **Disclaimer:** This app is a decision-support tool only. Always consult a qualified agronomist before applying any pesticide or fungicide treatment. The authors accept no liability for crop losses arising from reliance on the app's predictions.

---

## 🙏 Acknowledgements

- **Dataset:** [kamal01 on Kaggle](https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease) for the labelled crop disease images
- **Model:** [MobileNetV2](https://arxiv.org/abs/1801.04381) by Google Research, pre-trained on ImageNet
- **Framework:** [TensorFlow Lite](https://www.tensorflow.org/lite) for on-device inference
- **UI:** [Flutter](https://flutter.dev) by Google
- **Inspiration:** The farmers of West Bengal, whose livelihoods depend on healthy harvests

---

<div align="center">

Made with ❤️ for the farmers of West Bengal

**কৃষকদের জন্য তৈরি করা হয়েছে**

⭐ Star this repo if you find it useful · 🐛 [Report a bug](../../issues/new?template=bug_report.md) · 💡 [Request a feature](../../issues/new?template=feature_request.md)

</div>
