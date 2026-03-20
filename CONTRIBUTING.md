# Contributing to WB Crop Disease Detector

Thank you for your interest in improving this project! Contributions from farmers, developers, agronomists, and ML researchers are all welcome.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Adding New Disease Classes](#adding-new-disease-classes)
- [Improving Translations](#improving-translations)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Style Guide](#style-guide)

---

## Code of Conduct

This project is committed to creating a welcoming environment for everyone. Please be respectful and constructive in all interactions.

---

## How to Contribute

| Type | Description |
|------|-------------|
| 🐛 Bug fix | Fix a crash, incorrect translation, or wrong treatment |
| 📸 Screenshots | Add real device photos to `dataset_info/screenshots/` |
| 🌿 New disease | Add a new class to the disease database and/or training data |
| 🗣️ Translation | Correct or improve Bengali/Hindi/English text |
| 🧪 Training data | Contribute locally photographed crop disease images |
| 📖 Documentation | Improve README, dataset docs, or code comments |
| ✨ New feature | Voice output, new crop support, weather alerts, etc. |

---

## Development Setup

### Flutter App

```bash
git clone https://github.com/YOUR_USERNAME/wb-crop-disease-detector.git
cd wb-crop-disease-detector/app
flutter pub get

# Generate placeholder model if you don't have the trained one:
cd ../training && python generate_placeholder_model.py

# Run the app:
cd ../app && flutter run
```

### Training Pipeline

```bash
cd training
pip install -r requirements.txt

# Download dataset (requires Kaggle credentials):
python 01_download_and_prepare.py

# Train:
python 02_train_model.py

# Convert:
python 03_convert_tflite.py
```

---

## Adding New Disease Classes

### Step 1 — Add training data

Place labelled images in the correct split folders:
```
training/data/processed/splits/train/YourCrop_DiseaseName/
training/data/processed/splits/val/YourCrop_DiseaseName/
training/data/processed/splits/test/YourCrop_DiseaseName/
```

Minimum recommended: **80 images** (60 train / 10 val / 10 test).

### Step 2 — Add disease info

Open `app/lib/models/disease_info.dart` and add a new `DiseaseInfo` entry to the `_db` map:

```dart
'YourCrop_DiseaseName': DiseaseInfo(
  diseaseKey: 'YourCrop_DiseaseName',
  cropType: 'yourcrop',        // rice | wheat | corn | potato | jute | ...
  causeType: 'fungal',         // fungal | bacterial | viral
  severity: 'high',            // high | medium | low
  displayName: {
    'en': 'Your Crop Disease Name',
    'bn': 'আপনার ফসলের রোগের নাম',
    'hi': 'आपकी फसल की बीमारी का नाम',
  },
  symptoms: {
    'en': 'Describe visible symptoms in simple, clear language...',
    'bn': 'বাংলায় লক্ষণ বর্ণনা করুন...',
    'hi': 'हिंदी में लक्षण...',
  },
  cause: {
    'en': 'Caused by [organism]. Favours [conditions].',
    'bn': '[বাংলায়]...',
    'hi': '[हिंदी में]...',
  },
  treatment: {
    'en': '1. Apply [fungicide] @ [rate].\n2. Remove infected...',
    'bn': '১. [ছত্রাকনাশক] প্রয়োগ করুন...',
    'hi': '1. [फफूंदनाशक] लगाएं...',
  },
  prevention: {
    'en': 'Use resistant varieties. Crop rotation...',
    'bn': 'প্রতিরোধী জাত ব্যবহার করুন...',
    'hi': 'प्रतिरोधी किस्में...',
  },
),
```

### Step 3 — Retrain and test

```bash
cd training
python 02_train_model.py
python 03_convert_tflite.py
cd ../app
flutter run --release
```

### Step 4 — Submit a PR

Include in your PR description:
- Number of images added per split
- Source of the images (photographed yourself / public dataset)
- Test accuracy on the new class

---

## Improving Translations

All user-facing strings are in `app/lib/l10n/`:
- `app_en.arb` — English (source of truth)
- `app_bn.arb` — Bengali
- `app_hi.arb` — Hindi

And all disease text is in `app/lib/models/disease_info.dart`.

If you find a translation error or awkward phrasing:
1. Open the relevant file
2. Make the correction
3. Submit a PR with a brief explanation of what was wrong and why your version is better

Native speaker review is especially appreciated for treatment terminology (fungicide names, application rates) — these must be accurate.

---

## Submitting a Pull Request

1. **Fork** the repo and create a branch: `git checkout -b fix/typo-in-bengali-translation`
2. **Make your changes** and test them
3. **Run the checks:**
   ```bash
   cd app
   flutter analyze
   dart format .
   flutter test
   ```
4. **Commit** with a clear message following [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: add jute yellow mite disease class
   fix: correct Bengali translation for 'prevention'
   docs: add device screenshots for v1.0
   ```
5. **Push** and open a PR against `main`
6. Describe what you changed and why

---

## Style Guide

### Dart

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- All public classes and methods must have doc comments
- Use `const` constructors wherever possible
- Prefer named parameters for functions with 3+ arguments
- Max line length: 100 characters

### Python

- PEP 8 compliance (`flake8` will check this in CI)
- Type hints on all function signatures
- Docstrings on all public functions
- Max line length: 120 characters

### Commit messages

```
type(scope): short description

Longer explanation if needed. Wrap at 72 chars.

Fixes #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

---

Thank you for contributing! Every improvement helps farmers in West Bengal detect and treat crop diseases earlier.

🌾 *জয় কিষান!*
