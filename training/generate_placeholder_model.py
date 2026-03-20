#!/usr/bin/env python3
"""
generate_placeholder_model.py
─────────────────────────────
Creates a tiny but valid MobileNetV2-based TFLite model so the Flutter
project can be compiled and the APK can be built WITHOUT running the full
training pipeline.

Usage:
    pip install tensorflow --break-system-packages
    python generate_placeholder_model.py

Output:
    flutter_app/assets/model/model.tflite   (~4 MB placeholder)

Replace this file with the real model produced by:
    python ml_pipeline/scripts/02_train_model.py
    python ml_pipeline/scripts/03_convert_tflite.py
"""

import os, sys
from pathlib import Path

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

try:
    import tensorflow as tf
    import numpy as np
except ImportError:
    print("❌  TensorFlow not installed.")
    print("    Run:  pip install tensorflow --break-system-packages")
    sys.exit(1)

# ── Config ────────────────────────────────────────────────────────────────────
NUM_CLASSES = 15
IMG_SIZE    = 224
OUT_DIR     = Path(__file__).parent / "flutter_app" / "assets" / "model"
OUT_DIR.mkdir(parents=True, exist_ok=True)

LABELS = [
    "Healthy_Rice", "Healthy_Wheat", "Healthy_Corn", "Healthy_Potato",
    "Rice_Brown_Spot", "Rice_Leaf_Blast", "Rice_Neck_Blast",
    "Wheat_Brown_Rust", "Wheat_Yellow_Rust", "Wheat_Loose_Smut",
    "Corn_Common_Rust", "Corn_Gray_Leaf_Spot", "Corn_Northern_Leaf_Blight",
    "Potato_Early_Blight", "Potato_Late_Blight",
]

print("🏗️   Building placeholder MobileNetV2 TFLite model …")
print(f"    Classes : {NUM_CLASSES}")
print(f"    Input   : {IMG_SIZE}×{IMG_SIZE}×3")

# ── Build minimal model ────────────────────────────────────────────────────────
base = tf.keras.applications.MobileNetV2(
    input_shape=(IMG_SIZE, IMG_SIZE, 3),
    include_top=False,
    weights=None,           # random weights — training hasn't happened yet
)
inputs  = tf.keras.Input(shape=(IMG_SIZE, IMG_SIZE, 3))
x       = tf.keras.applications.mobilenet_v2.preprocess_input(
              tf.cast(inputs, tf.float32))
x       = base(x, training=False)
x       = tf.keras.layers.GlobalAveragePooling2D()(x)
x       = tf.keras.layers.Dense(128, activation="relu")(x)
outputs = tf.keras.layers.Dense(NUM_CLASSES, activation="softmax")(x)
model   = tf.keras.Model(inputs, outputs)

# ── Convert to TFLite (dynamic quantisation) ──────────────────────────────────
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_bytes = converter.convert()

out_path = OUT_DIR / "model.tflite"
out_path.write_bytes(tflite_bytes)
size_mb  = len(tflite_bytes) / (1024 * 1024)

# ── Write labels ──────────────────────────────────────────────────────────────
(OUT_DIR / "labels.txt").write_text("\n".join(LABELS))

print(f"\n✅  Placeholder model written → {out_path}  ({size_mb:.1f} MB)")
print(f"    Labels   written → {OUT_DIR / 'labels.txt'}")
print("""
⚠️   IMPORTANT: This model has RANDOM weights and will give random predictions.
    Replace it with the trained model after running:
        python ml_pipeline/scripts/02_train_model.py
        python ml_pipeline/scripts/03_convert_tflite.py
""")
