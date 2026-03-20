# Class Distribution

Approximate image counts per class in the Kaggle dataset.
Exact counts depend on the dataset version downloaded.

| Class | Approx. Images | Train | Val | Test |
|-------|---------------|-------|-----|------|
| Healthy Rice | ~90 | 72 | 9 | 9 |
| Healthy Wheat | ~85 | 68 | 8 | 9 |
| Healthy Corn | ~90 | 72 | 9 | 9 |
| Healthy Potato | ~152 | 122 | 15 | 15 |
| Rice Brown Spot | ~100 | 80 | 10 | 10 |
| Rice Leaf Blast | ~90 | 72 | 9 | 9 |
| Rice Neck Blast | ~85 | 68 | 8 | 9 |
| Wheat Brown Rust | ~80 | 64 | 8 | 8 |
| Wheat Yellow Rust | ~80 | 64 | 8 | 8 |
| Wheat Loose Smut | ~75 | 60 | 7 | 8 |
| Corn Common Rust | ~90 | 72 | 9 | 9 |
| Corn Gray Leaf Spot | ~85 | 68 | 8 | 9 |
| Corn N. Leaf Blight | ~88 | 70 | 9 | 9 |
| Potato Early Blight | ~152 | 122 | 15 | 15 |
| Potato Late Blight | ~152 | 122 | 15 | 15 |
| **TOTAL** | **~1,294** | **~1,076** | **~137** | **~141** |

## Notes

- Split ratios: 80 / 10 / 10
- Random seed: 42 (reproducible)
- Imbalance: Potato classes have ~1.7× more images than wheat classes
- The training script does not apply class weighting by default; add it in `02_train_model.py` if imbalance causes issues

## Improving with Local Data

The model will generalise better if you supplement it with photographs taken
in West Bengal field conditions. Recommended additions:

| Disease | Why it needs more data |
|---------|----------------------|
| Rice Neck Blast | High severity, visual symptoms at panicle stage |
| Wheat Loose Smut | Fewer images in base dataset |
| Corn Gray Leaf Spot | High variability in lesion appearance |

To add images, place them in the correct split folder before training:
```
training/data/processed/splits/train/Rice_Neck_Blast/
training/data/processed/splits/val/Rice_Neck_Blast/
```
