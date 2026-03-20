# Model Training

Complete guide to reproducing the trained crop disease detection model from scratch.

---

## Requirements

```bash
pip install -r requirements.txt
```

| Package | Version | Purpose |
|---------|---------|---------|
| tensorflow | ≥ 2.13.0 | Model training + TFLite conversion |
| numpy | ≥ 1.24.0 | Array operations |
| matplotlib | ≥ 3.7.0 | Training curves |
| seaborn | ≥ 0.12.0 | Confusion matrix |
| scikit-learn | ≥ 1.3.0 | Classification report |
| Pillow | ≥ 9.5.0 | Image I/O |
| kaggle | ≥ 1.5.16 | Dataset download |

**Hardware:** GPU strongly recommended for training. CPU training works but takes 4–8 hours.

---

## Quick Start

```bash
# Full pipeline (download → train → convert → copy to app)
bash build_all.sh

# Step by step:
python 01_download_and_prepare.py
python 02_train_model.py
python 03_convert_tflite.py
```

---

## Script Reference

### `01_download_and_prepare.py`

Downloads the [Kaggle crop disease dataset](https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease) and creates 80/10/10 train/val/test splits.

**Prerequisites:**
```bash
pip install kaggle
# Place ~/.kaggle/kaggle.json with your API credentials
```

**Usage:**
```bash
python 01_download_and_prepare.py
python 01_download_and_prepare.py --skip-download   # If already extracted
```

**Outputs:**
```
data/processed/splits/
├── train/   (~1,040 images across 15 class folders)
├── val/     (~130 images)
└── test/    (~130 images)
data/dataset_summary.json
models/labels.txt
```

---

### `02_train_model.py`

Trains MobileNetV2 with transfer learning in two phases.

**Usage:**
```bash
python 02_train_model.py
```

**Configuration (edit at top of file):**
```python
IMG_SIZE   = 224      # Input resolution
BATCH_SIZE = 32       # Reduce to 16 if OOM
EPOCHS     = 60       # Phase 1 max epochs
LR_INIT    = 1e-3     # Phase 1 learning rate
LR_FINE    = 1e-5     # Phase 2 learning rate
SEED       = 42       # Reproducibility
```

**Phase 1 — Head training (~60 epochs)**
- MobileNetV2 backbone frozen
- Only classification head trained
- LR=1e-3, Adam optimiser
- Early stopping patience=10

**Phase 2 — Fine-tuning (~30 epochs)**
- Top 50 MobileNetV2 layers unfrozen
- LR=1e-5 (10× smaller to avoid destroying features)
- Early stopping patience=10

**Outputs:**
```
models/
├── crop_disease_model.keras       Final trained model
├── best_model_phase1.keras        Best checkpoint Phase 1
├── best_model_phase2.keras        Best checkpoint Phase 2
├── labels.txt                     Class names
└── model_metadata.json            Accuracy, class list
logs/
├── training_report.png            Accuracy/loss curves + confusion matrix
├── classification_report.txt      Per-class precision/recall/F1
├── history_phase1.csv             Epoch-by-epoch metrics
└── history_phase2.csv
```

**Expected training time:**
| Hardware | Phase 1 | Phase 2 | Total |
|----------|---------|---------|-------|
| NVIDIA RTX 3060 | ~8 min | ~4 min | ~12 min |
| NVIDIA T4 (Colab) | ~15 min | ~7 min | ~22 min |
| CPU only (8-core) | ~4 hrs | ~2 hrs | ~6 hrs |

**Expected accuracy:**
| Split | Accuracy |
|-------|----------|
| Train | ~95% |
| Validation | ~88% |
| Test | ~85–92% |

---

### `03_convert_tflite.py`

Converts the trained Keras model to TensorFlow Lite with three quantisation levels.

**Usage:**
```bash
python 03_convert_tflite.py
```

**Outputs:**
```
models/
├── crop_disease_dynamic.tflite    Dynamic-range quantisation
├── crop_disease_fp16.tflite       FP16 quantisation (RECOMMENDED)
└── crop_disease_int8.tflite       INT8 quantisation (smallest)

# Best model auto-copied to Flutter:
../app/assets/model/model.tflite
```

**Quantisation comparison:**

| Variant | Size | Accuracy | Speed | Recommended |
|---------|------|----------|-------|-------------|
| FP32 (no quant) | ~14 MB | Baseline | 1× | No (too large) |
| Dynamic | ~7 MB | −0.5% | 2–4× | Testing only |
| **FP16** | **~7 MB** | **−0.5%** | **2–4×** | **✅ Yes** |
| INT8 | ~4 MB | −1–2% | 4–6× | Low-end devices |

---

### `generate_placeholder_model.py`

Creates a valid but untrained TFLite model for testing the Flutter build pipeline without running the full training.

```bash
python generate_placeholder_model.py
# Writes: ../app/assets/model/model.tflite (~5 MB, random weights)
```

⚠️ This model will give random predictions — for UI/build testing only.

---

## Training on Google Colab

Free GPU training with no local setup:

```python
# In a Colab cell:
!pip install kaggle tensorflow matplotlib seaborn scikit-learn

# Upload your kaggle.json
from google.colab import files
files.upload()  # Select kaggle.json

!mkdir ~/.kaggle && cp kaggle.json ~/.kaggle/ && chmod 600 ~/.kaggle/kaggle.json

# Clone repo and run
!git clone https://github.com/YOUR_USERNAME/wb-crop-disease-detector.git
%cd wb-crop-disease-detector/training
!python 01_download_and_prepare.py
!python 02_train_model.py
!python 03_convert_tflite.py

# Download the model
from google.colab import files
files.download('models/crop_disease_fp16.tflite')
```

---

## Improving Model Accuracy

| Technique | Expected gain | Effort |
|-----------|--------------|--------|
| More training images | +3–8% | Medium |
| EfficientNetB3 backbone | +2–5% | Low |
| Increase EPOCHS to 100 | +1–3% | Low |
| Test-time augmentation | +1–2% | Medium |
| Ensemble (3 models) | +3–5% | High |
| Class-balanced sampling | +1–3% | Low |

### Switching to EfficientNetB3

In `02_train_model.py`, replace:
```python
from tensorflow.keras.applications import MobileNetV2
base_model = MobileNetV2(input_shape=(IMG_SIZE, IMG_SIZE, 3), ...)
preprocess_input = keras.applications.mobilenet_v2.preprocess_input
```

With:
```python
from tensorflow.keras.applications import EfficientNetB3
IMG_SIZE = 300  # EfficientNetB3 native resolution
base_model = EfficientNetB3(input_shape=(IMG_SIZE, IMG_SIZE, 3), ...)
preprocess_input = keras.applications.efficientnet.preprocess_input
```

Note: EfficientNetB3 produces a larger TFLite model (~25 MB) and slower inference.
