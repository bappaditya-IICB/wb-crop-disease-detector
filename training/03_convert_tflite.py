#!/usr/bin/env python3
"""
KrishakAI - Step 3: TFLite Conversion
Converts the trained Keras model to TFLite with INT8 quantization.
"""

import os, sys, json, shutil
from pathlib import Path
import numpy as np

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import tensorflow as tf

BASE_DIR   = Path(__file__).resolve().parent.parent
DATA_DIR   = BASE_DIR / "data"
MODEL_DIR  = BASE_DIR / "models"
SPLITS_DIR = DATA_DIR / "processed" / "splits"
FLUTTER_ASSETS = (
    BASE_DIR.parent / "flutter_app" / "assets" / "model"
)
FLUTTER_ASSETS.mkdir(parents=True, exist_ok=True)

IMG_SIZE = 224


def representative_dataset_gen():
    """
    Yields calibration batches from the validation split for INT8 quantization.
    """
    val_dir = SPLITS_DIR / "val"
    if not val_dir.exists():
        print("⚠️  Validation split not found – using random data for calibration")
        for _ in range(100):
            yield [np.random.rand(1, IMG_SIZE, IMG_SIZE, 3).astype(np.float32)]
        return

    ds = tf.keras.utils.image_dataset_from_directory(
        val_dir,
        image_size=(IMG_SIZE, IMG_SIZE),
        batch_size=1,
        shuffle=True,
    )
    count = 0
    for images, _ in ds.take(200):
        # MobileNetV2 expects [-1, 1]
        images = tf.keras.applications.mobilenet_v2.preprocess_input(
            tf.cast(images, tf.float32)
        )
        yield [images.numpy()]
        count += 1
    print(f"   Used {count} calibration samples")


def convert_float16():
    """Float16 quantization – good balance of size/accuracy."""
    model_path = str(MODEL_DIR / "crop_disease_model.keras")
    model = tf.keras.models.load_model(model_path)

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]

    tflite_model = converter.convert()
    out_path = MODEL_DIR / "crop_disease_fp16.tflite"
    out_path.write_bytes(tflite_model)
    size_mb = out_path.stat().st_size / (1024 * 1024)
    print(f"✅  FP16 model: {out_path}  ({size_mb:.2f} MB)")
    return out_path


def convert_int8():
    """Full INT8 quantization – smallest size, fastest on mobile."""
    model_path = str(MODEL_DIR / "crop_disease_model.keras")
    model = tf.keras.models.load_model(model_path)

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.representative_dataset = representative_dataset_gen
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS_INT8
    ]
    converter.inference_input_type  = tf.uint8
    converter.inference_output_type = tf.uint8

    tflite_model = converter.convert()
    out_path = MODEL_DIR / "crop_disease_int8.tflite"
    out_path.write_bytes(tflite_model)
    size_mb = out_path.stat().st_size / (1024 * 1024)
    print(f"✅  INT8 model: {out_path}  ({size_mb:.2f} MB)")
    return out_path


def convert_dynamic():
    """Dynamic-range quantization – fast, no calibration needed."""
    model_path = str(MODEL_DIR / "crop_disease_model.keras")
    model = tf.keras.models.load_model(model_path)

    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]

    tflite_model = converter.convert()
    out_path = MODEL_DIR / "crop_disease_dynamic.tflite"
    out_path.write_bytes(tflite_model)
    size_mb = out_path.stat().st_size / (1024 * 1024)
    print(f"✅  Dynamic model: {out_path}  ({size_mb:.2f} MB)")
    return out_path


def benchmark_model(tflite_path: Path, num_runs: int = 20):
    """Run inference benchmark on the TFLite model."""
    import time

    interpreter = tf.lite.Interpreter(model_path=str(tflite_path))
    interpreter.allocate_tensors()

    input_details  = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    in_shape = input_details[0]["shape"]

    # Determine dtype
    in_dtype = input_details[0]["dtype"]
    if in_dtype == np.uint8:
        dummy = np.random.randint(0, 255, in_shape, dtype=np.uint8)
    else:
        dummy = np.random.rand(*in_shape).astype(np.float32)

    # Warmup
    for _ in range(3):
        interpreter.set_tensor(input_details[0]["index"], dummy)
        interpreter.invoke()

    # Benchmark
    start = time.perf_counter()
    for _ in range(num_runs):
        interpreter.set_tensor(input_details[0]["index"], dummy)
        interpreter.invoke()
    elapsed = (time.perf_counter() - start) / num_runs * 1000

    output = interpreter.get_tensor(output_details[0]["index"])
    print(f"   Input shape : {in_shape}  dtype={in_dtype}")
    print(f"   Avg latency : {elapsed:.1f} ms per image (CPU, {num_runs} runs)")
    print(f"   Output shape: {output.shape}")
    return elapsed


def copy_to_flutter(best_model_path: Path):
    """Copy the chosen model + labels into the Flutter assets directory."""
    # Model
    dest_model = FLUTTER_ASSETS / "model.tflite"
    shutil.copy2(best_model_path, dest_model)
    print(f"\n📱  Copied model → {dest_model}")

    # Labels
    labels_src = MODEL_DIR / "labels.txt"
    if labels_src.exists():
        shutil.copy2(labels_src, FLUTTER_ASSETS / "labels.txt")
        print(f"📱  Copied labels → {FLUTTER_ASSETS / 'labels.txt'}")
    else:
        print("⚠️  labels.txt not found in models/ – generate it with training script.")


def main():
    print("=" * 60)
    print("  KrishakAI – TFLite Conversion & Optimization")
    print("=" * 60)

    keras_model = MODEL_DIR / "crop_disease_model.keras"
    if not keras_model.exists():
        print(f"❌  Trained model not found at: {keras_model}")
        print("    Run 02_train_model.py first.")
        sys.exit(1)

    print("\n🔄  Converting to TFLite (3 variants) …\n")

    dynamic_path = convert_dynamic()
    fp16_path    = convert_float16()

    print("\n⏱️  Benchmarking …")
    print(f"\n  Dynamic quantization ({dynamic_path.name}):")
    dynamic_ms = benchmark_model(dynamic_path)

    print(f"\n  FP16 quantization ({fp16_path.name}):")
    fp16_ms = benchmark_model(fp16_path)

    # INT8 needs calibration data – only attempt if splits exist
    if (SPLITS_DIR / "val").exists():
        print("\n  INT8 quantization (with calibration) …")
        int8_path = convert_int8()
        print(f"\n  INT8 ({int8_path.name}):")
        int8_ms = benchmark_model(int8_path)
        best_model = fp16_path  # FP16 is safest for accuracy
    else:
        print("\n⚠️  Skipping INT8 (no calibration data). Using FP16 as default.")
        best_model = fp16_path

    # Copy best model to Flutter
    copy_to_flutter(best_model)

    # Summary
    print("\n" + "=" * 60)
    print("  Conversion Summary")
    print("=" * 60)
    for path in [dynamic_path, fp16_path]:
        mb = path.stat().st_size / (1024 * 1024)
        print(f"  {path.name:35s}  {mb:6.2f} MB")

    print(f"\n✅  Best model for deployment: {best_model.name}")
    print("    Deploy this file as assets/model/model.tflite in Flutter\n")


if __name__ == "__main__":
    main()
