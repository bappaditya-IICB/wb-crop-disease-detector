# 📦 Dataset Information

## Source

| Property | Details |
|----------|---------|
| **Name** | Top Agriculture Crop Disease |
| **URL** | https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease |
| **Author** | kamal01 |
| **Platform** | Kaggle |
| **Licence** | See Kaggle dataset page for licence terms |

---

## Overview

A multi-crop leaf disease dataset covering four crops commonly grown in West Bengal and across India. Images are labelled JPEG/PNG photographs of crop leaves taken under field and laboratory conditions.

| Crop | Disease Classes | Healthy Class | Total Classes |
|------|----------------|---------------|---------------|
| Rice | 3 | 1 | 4 |
| Wheat | 3 | 1 | 4 |
| Corn | 3 | 1 | 4 |
| Potato | 2 | 1 | 3 |
| **Total** | **11** | **4** | **15** |

Approximate total: **~1,300 labelled images**

---

## Class List

| # | Class Label (folder name) | Display Name | Crop | Type | Severity |
|---|--------------------------|-------------|------|------|----------|
| 0 | `Healthy_Rice` | Healthy Rice | Rice | — | — |
| 1 | `Healthy_Wheat` | Healthy Wheat | Wheat | — | — |
| 2 | `Healthy_Corn` | Healthy Corn | Corn | — | — |
| 3 | `Healthy_Potato` | Healthy Potato | Potato | — | — |
| 4 | `Rice_Brown_Spot` | Rice Brown Spot | Rice | Fungal | High |
| 5 | `Rice_Leaf_Blast` | Rice Leaf Blast | Rice | Fungal | High |
| 6 | `Rice_Neck_Blast` | Rice Neck Blast | Rice | Fungal | High |
| 7 | `Wheat_Brown_Rust` | Wheat Brown Rust | Wheat | Fungal | High |
| 8 | `Wheat_Yellow_Rust` | Wheat Yellow Rust | Wheat | Fungal | High |
| 9 | `Wheat_Loose_Smut` | Wheat Loose Smut | Wheat | Fungal | Medium |
| 10 | `Corn_Common_Rust` | Corn Common Rust | Corn | Fungal | Medium |
| 11 | `Corn_Gray_Leaf_Spot` | Corn Gray Leaf Spot | Corn | Fungal | Medium |
| 12 | `Corn_Northern_Leaf_Blight` | Corn N. Leaf Blight | Corn | Fungal | High |
| 13 | `Potato_Early_Blight` | Potato Early Blight | Potato | Fungal | Medium |
| 14 | `Potato_Late_Blight` | Potato Late Blight | Potato | Fungal | High |

---

## Data Splits

```
Total images  ≈ 1,300
  Train       ≈ 1,040  (80%)
  Validation  ≈   130  (10%)
  Test        ≈   130  (10%)
```

Splits are created by `training/01_download_and_prepare.py` using a fixed random seed (`SEED=42`) for reproducibility. Classes are stratified by folder.

---

## Preprocessing Pipeline

```
Raw image (any size, JPG/PNG)
    ↓
cv2 / Pillow decode
    ↓
Resize to 224 × 224 (bilinear interpolation)
    ↓
Cast to float32
    ↓
MobileNetV2 preprocess_input
  = pixel / 127.5 − 1.0
  → range [−1.0, +1.0]
    ↓
Input tensor: shape (1, 224, 224, 3)
```

---

## Data Augmentation (training only)

The following augmentations are applied on-the-fly during training using Keras `tf.keras.layers.Random*` layers (executed on-GPU, zero preprocessing overhead at inference):

| Augmentation | Parameter |
|-------------|-----------|
| RandomFlip | horizontal_and_vertical |
| RandomRotation | ±25° (factor=0.25) |
| RandomZoom | ±20% (factor=0.20) |
| RandomTranslation | ±10% height, ±10% width |
| RandomBrightness | ±20% (factor=0.20) |
| RandomContrast | ±20% (factor=0.20) |

These augmentations are embedded in the model graph (inside the `augmentation` sequential layer) and are **automatically disabled** at inference time when `training=False`.

---

## Known Limitations

- Small dataset size (~1,300 images) — model may struggle with unusual lighting or exotic symptom presentations.
- No images specific to West Bengal field conditions — accuracy may improve with locally photographed images.
- All disease classes are fungal; the model is not trained to detect bacterial or viral diseases.
- Image quality in the dataset is mixed; some photos have backgrounds or multiple leaves.

---

## How to Download

```bash
# Install Kaggle CLI
pip install kaggle

# Place your API key at ~/.kaggle/kaggle.json
# Get it from: https://www.kaggle.com/settings → API → Create New Token

# Download and unzip
kaggle datasets download -d kamal01/top-agriculture-crop-disease -p training/data/raw --unzip
```

Or download manually from https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease and extract into `training/data/raw/`.

---

## Citation

If you use this dataset in academic work, please cite:

```
kamal01. (2023). Top Agriculture Crop Disease [Dataset].
Kaggle. https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease
```

---

## Screenshots

Place real device screenshots here to help new contributors understand the app:

```
dataset_info/screenshots/
├── splash.png
├── language.png
├── home.png
├── analyzing.png
└── result.png
```

See [Contributing](../README.md#-contributing) for how to add screenshots.
