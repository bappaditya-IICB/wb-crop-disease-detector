# Model Files

## Why is `model.tflite` not in this folder?

TFLite model files are binary blobs that can be **50–150 MB** for full-precision models. Committing large binaries to Git:

- Bloats repository clone time for all contributors
- Cannot be reviewed in pull requests
- Makes `git history` slow

Instead, the trained `model.tflite` is published as a **GitHub Release asset** and downloaded separately.

---

## Download the trained model

**Option A — GitHub Releases (recommended)**

1. Go to [Releases](../../../releases/latest)
2. Download `model.tflite`
3. Place it at: `app/assets/model/model.tflite`

**Option B — Command line (gh CLI)**

```bash
gh release download v1.0.0 --pattern "model.tflite" --dir app/assets/model/
```

**Option C — wget**

```bash
wget -O app/assets/model/model.tflite \
  https://github.com/YOUR_USERNAME/wb-crop-disease-detector/releases/download/v1.0.0/model.tflite
```

---

## Train your own model

```bash
cd training
pip install -r requirements.txt

# Download dataset (requires Kaggle credentials):
python 01_download_and_prepare.py

# Train MobileNetV2:
python 02_train_model.py

# Convert to TFLite + quantise:
python 03_convert_tflite.py

# The best model is automatically copied to:
# app/assets/model/model.tflite
```

---

## Generate a placeholder (for UI testing)

If you just want to compile and run the Flutter app without real predictions:

```bash
cd training
pip install tensorflow
python generate_placeholder_model.py
# Writes app/assets/model/model.tflite (~5 MB, random weights)
```

---

## Model specifications

| Property | Value |
|----------|-------|
| Architecture | MobileNetV2 |
| Input | 224 × 224 × 3 float32 |
| Output | 15-class softmax |
| Format | TensorFlow Lite FP16 |
| Size | ~8 MB |
| Inference (ARM64 CPU) | ~150–400 ms |

## Files in this directory

| File | Description |
|------|-------------|
| `labels.txt` | Class names in order (index 0 = first line) |
| `model.tflite` | ← **Download from Releases** (not in repo) |
