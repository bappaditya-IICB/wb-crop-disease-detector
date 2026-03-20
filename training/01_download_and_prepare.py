#!/usr/bin/env python3
"""
KrishakAI - Step 1: Dataset Download & Preparation
Dataset: https://www.kaggle.com/datasets/kamal01/top-agriculture-crop-disease
"""

import os
import sys
import json
import shutil
import random
import argparse
from pathlib import Path

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
RAW_DIR  = DATA_DIR / "raw"
PROCESSED_DIR = DATA_DIR / "processed"

SPLITS = {"train": 0.80, "val": 0.10, "test": 0.10}
SEED   = 42
IMG_SIZE = 224

# ─────────────────────────────────────────────
# Class mapping (Kaggle dataset folder names → display names)
# ─────────────────────────────────────────────
CLASS_MAP = {
    # Rice
    "Rice___Brown_Spot":            "Rice Brown Spot",
    "Rice___Leaf_Blast":            "Rice Leaf Blast",
    "Rice___Neck_Blast":            "Rice Neck Blast",
    "Rice___Healthy":               "Healthy Rice",
    # Wheat
    "Wheat___Brown_Rust":           "Wheat Brown Rust",
    "Wheat___Yellow_Rust":          "Wheat Yellow Rust",
    "Wheat___Loose_Smut":           "Wheat Loose Smut",
    "Wheat___Healthy":              "Healthy Wheat",
    # Corn / Maize
    "Corn___Common_Rust":           "Corn Common Rust",
    "Corn___Gray_Leaf_Spot":        "Corn Gray Leaf Spot",
    "Corn___Northern_Leaf_Blight":  "Corn Northern Leaf Blight",
    "Corn___Healthy":               "Healthy Corn",
    # Potato
    "Potato___Early_Blight":        "Potato Early Blight",
    "Potato___Late_Blight":         "Potato Late Blight",
    "Potato___Healthy":             "Healthy Potato",
}


def download_dataset():
    """
    Downloads dataset via Kaggle CLI.
    Requires ~/.kaggle/kaggle.json with your API credentials.
    """
    print("\n📥  Downloading dataset from Kaggle …")
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    try:
        import subprocess
        result = subprocess.run(
            [
                "kaggle", "datasets", "download",
                "-d", "kamal01/top-agriculture-crop-disease",
                "-p", str(RAW_DIR),
                "--unzip",
            ],
            check=True, capture_output=True, text=True,
        )
        print(result.stdout)
        print("✅  Download complete.")
    except FileNotFoundError:
        print("⚠️  Kaggle CLI not found. Install with:  pip install kaggle")
        print("    Then place your API key at ~/.kaggle/kaggle.json")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print("❌  Kaggle download failed:", e.stderr)
        sys.exit(1)


def discover_classes(source_root: Path):
    """Return list of (folder_path, class_name) for every class folder found."""
    classes = []
    for p in sorted(source_root.rglob("*")):
        if p.is_dir() and p.name in CLASS_MAP:
            classes.append((p, CLASS_MAP[p.name]))
        elif p.is_dir():
            # Try fuzzy match – handle slight naming variations
            for key in CLASS_MAP:
                if key.lower() in p.name.lower() or p.name.lower() in key.lower():
                    classes.append((p, CLASS_MAP[key]))
                    break
    return classes


def split_and_copy(class_folder: Path, class_label: str, split_root: Path):
    """Split images in *class_folder* into train/val/test and copy them."""
    images = [
        f for f in class_folder.iterdir()
        if f.suffix.lower() in {".jpg", ".jpeg", ".png", ".bmp", ".tiff"}
    ]
    random.shuffle(images)

    n = len(images)
    n_train = int(n * SPLITS["train"])
    n_val   = int(n * SPLITS["val"])

    splits_idx = {
        "train": images[:n_train],
        "val":   images[n_train : n_train + n_val],
        "test":  images[n_train + n_val :],
    }

    safe_label = class_label.replace(" ", "_")
    for split_name, files in splits_idx.items():
        dest = split_root / split_name / safe_label
        dest.mkdir(parents=True, exist_ok=True)
        for f in files:
            shutil.copy2(f, dest / f.name)

    return {s: len(v) for s, v in splits_idx.items()}


def build_labels_json(split_root: Path):
    """Write labels.json consumed by the Flutter app and training pipeline."""
    classes = sorted(
        [d.name for d in (split_root / "train").iterdir() if d.is_dir()]
    )
    labels_path = BASE_DIR / "models" / "labels.txt"
    labels_path.parent.mkdir(parents=True, exist_ok=True)
    labels_path.write_text("\n".join(classes))
    print(f"\n📋  {len(classes)} classes written to {labels_path}")
    return classes


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--skip-download", action="store_true",
                        help="Skip Kaggle download (use already-extracted data in data/raw/)")
    args = parser.parse_args()

    random.seed(SEED)

    if not args.skip_download:
        download_dataset()

    # Auto-locate the root of extracted dataset
    source_root = RAW_DIR
    # Sometimes Kaggle extracts into a subdirectory
    subdirs = [d for d in RAW_DIR.iterdir() if d.is_dir()]
    if len(subdirs) == 1:
        source_root = subdirs[0]

    print(f"\n🔍  Scanning for class folders in: {source_root}")
    classes = discover_classes(source_root)

    if not classes:
        print("❌  No recognised class folders found.")
        print("    Ensure the dataset is extracted inside:", RAW_DIR)
        sys.exit(1)

    print(f"✅  Found {len(classes)} classes: {[c for _, c in classes]}")

    split_root = PROCESSED_DIR / "splits"
    summary = {}

    for folder, label in classes:
        counts = split_and_copy(folder, label, split_root)
        summary[label] = counts
        total = sum(counts.values())
        print(f"   {label:35s}  total={total:4d}  "
              f"train={counts['train']:4d}  val={counts['val']:3d}  test={counts['test']:3d}")

    # Save dataset summary
    summary_path = DATA_DIR / "dataset_summary.json"
    summary_path.write_text(json.dumps(summary, indent=2))
    print(f"\n📊  Summary saved to {summary_path}")

    classes_list = build_labels_json(split_root)

    print("\n✅  Dataset preparation complete!")
    print(f"    Splits location : {split_root}")
    print(f"    Total classes   : {len(classes_list)}")
    total_imgs = sum(sum(v.values()) for v in summary.values())
    print(f"    Total images    : {total_imgs}")


if __name__ == "__main__":
    main()
