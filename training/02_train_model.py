#!/usr/bin/env python3
"""
KrishakAI - Step 2: Model Training
Transfer Learning with MobileNetV2 + aggressive augmentation for small dataset.
"""

import os, sys, json, time, argparse
from pathlib import Path
import numpy as np

# ── Suppress TF info/warnings ──────────────────────────────────────────────
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, regularizers
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.callbacks import (
    EarlyStopping, ReduceLROnPlateau,
    ModelCheckpoint, TensorBoard, CSVLogger,
)
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from sklearn.metrics import confusion_matrix, classification_report
import seaborn as sns

# ─────────────────────────────────────────────
# Paths
# ─────────────────────────────────────────────
BASE_DIR   = Path(__file__).resolve().parent.parent
DATA_DIR   = BASE_DIR / "data"
SPLITS_DIR = DATA_DIR / "processed" / "splits"
MODEL_DIR  = BASE_DIR / "models"
LOGS_DIR   = BASE_DIR / "logs"
MODEL_DIR.mkdir(parents=True, exist_ok=True)
LOGS_DIR.mkdir(parents=True, exist_ok=True)

# ─────────────────────────────────────────────
# Hyper-parameters
# ─────────────────────────────────────────────
IMG_SIZE   = 224
BATCH_SIZE = 32
EPOCHS     = 60
LR_INIT    = 1e-3
LR_FINE    = 1e-5
SEED       = 42

tf.random.set_seed(SEED)
np.random.seed(SEED)


# ─────────────────────────────────────────────
# Data loading with strong augmentation
# ─────────────────────────────────────────────
def build_augmentation_layer():
    return keras.Sequential(
        [
            layers.RandomFlip("horizontal_and_vertical"),
            layers.RandomRotation(0.25),
            layers.RandomZoom(0.2),
            layers.RandomTranslation(0.1, 0.1),
            layers.RandomBrightness(0.2),
            layers.RandomContrast(0.2),
        ],
        name="augmentation",
    )


def load_datasets(splits_dir: Path):
    train_ds = keras.utils.image_dataset_from_directory(
        splits_dir / "train",
        image_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        shuffle=True,
        seed=SEED,
        label_mode="categorical",
    )
    val_ds = keras.utils.image_dataset_from_directory(
        splits_dir / "val",
        image_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        shuffle=False,
        label_mode="categorical",
    )
    test_ds = keras.utils.image_dataset_from_directory(
        splits_dir / "test",
        image_size=(IMG_SIZE, IMG_SIZE),
        batch_size=BATCH_SIZE,
        shuffle=False,
        label_mode="categorical",
    )
    class_names = train_ds.class_names
    num_classes = len(class_names)
    print(f"\n📂  Classes ({num_classes}): {class_names}")

    # Save class names
    (MODEL_DIR / "labels.txt").write_text("\n".join(class_names))

    # Prefetch for performance
    AUTOTUNE = tf.data.AUTOTUNE
    train_ds = train_ds.cache().prefetch(AUTOTUNE)
    val_ds   = val_ds.cache().prefetch(AUTOTUNE)
    test_ds  = test_ds.cache().prefetch(AUTOTUNE)

    return train_ds, val_ds, test_ds, class_names, num_classes


# ─────────────────────────────────────────────
# Model
# ─────────────────────────────────────────────
def build_model(num_classes: int):
    # Preprocessing: scale [0,255] → [-1,1] expected by MobileNetV2
    preprocess_input = keras.applications.mobilenet_v2.preprocess_input

    base_model = MobileNetV2(
        input_shape=(IMG_SIZE, IMG_SIZE, 3),
        include_top=False,
        weights="imagenet",
    )
    base_model.trainable = False  # frozen during phase-1

    inputs    = keras.Input(shape=(IMG_SIZE, IMG_SIZE, 3))
    x         = build_augmentation_layer()(inputs)
    x         = layers.Lambda(preprocess_input)(x)
    x         = base_model(x, training=False)
    x         = layers.GlobalAveragePooling2D()(x)
    x         = layers.BatchNormalization()(x)
    x         = layers.Dense(256, activation="relu",
                              kernel_regularizer=regularizers.l2(1e-4))(x)
    x         = layers.Dropout(0.50)(x)
    x         = layers.Dense(128, activation="relu",
                              kernel_regularizer=regularizers.l2(1e-4))(x)
    x         = layers.Dropout(0.30)(x)
    outputs   = layers.Dense(num_classes, activation="softmax")(x)

    model = keras.Model(inputs, outputs)
    return model, base_model


# ─────────────────────────────────────────────
# Callbacks
# ─────────────────────────────────────────────
def get_callbacks(phase: int):
    ckpt_path = str(MODEL_DIR / f"best_model_phase{phase}.keras")
    return [
        ModelCheckpoint(ckpt_path, monitor="val_accuracy",
                        save_best_only=True, verbose=1),
        EarlyStopping(monitor="val_accuracy", patience=10,
                      restore_best_weights=True, verbose=1),
        ReduceLROnPlateau(monitor="val_loss", factor=0.5, patience=4,
                          min_lr=1e-7, verbose=1),
        TensorBoard(log_dir=str(LOGS_DIR / f"phase{phase}")),
        CSVLogger(str(LOGS_DIR / f"history_phase{phase}.csv")),
    ]


# ─────────────────────────────────────────────
# Plotting helpers
# ─────────────────────────────────────────────
def plot_history(histories, class_names, test_ds, model, save_dir: Path):
    # Combine histories
    acc  = []
    val_acc  = []
    loss = []
    val_loss = []
    for h in histories:
        acc      += h.history["accuracy"]
        val_acc  += h.history["val_accuracy"]
        loss     += h.history["loss"]
        val_loss += h.history["val_loss"]

    fig = plt.figure(figsize=(18, 12))
    fig.suptitle("KrishakAI – Training Report", fontsize=16, fontweight="bold")
    gs  = gridspec.GridSpec(2, 2, figure=fig)

    # Accuracy
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.plot(acc,     label="Train Accuracy", linewidth=2)
    ax1.plot(val_acc, label="Val Accuracy",   linewidth=2, linestyle="--")
    ax1.set_title("Accuracy"); ax1.set_xlabel("Epoch"); ax1.legend()
    ax1.grid(alpha=0.3)

    # Loss
    ax2 = fig.add_subplot(gs[0, 1])
    ax2.plot(loss,     label="Train Loss", linewidth=2)
    ax2.plot(val_loss, label="Val Loss",   linewidth=2, linestyle="--")
    ax2.set_title("Loss"); ax2.set_xlabel("Epoch"); ax2.legend()
    ax2.grid(alpha=0.3)

    # Confusion Matrix
    print("\n📊  Computing confusion matrix …")
    y_true, y_pred = [], []
    for imgs, labels in test_ds:
        preds = model.predict(imgs, verbose=0)
        y_true.extend(np.argmax(labels.numpy(), axis=1))
        y_pred.extend(np.argmax(preds, axis=1))

    cm = confusion_matrix(y_true, y_pred)
    ax3 = fig.add_subplot(gs[1, :])
    sns.heatmap(cm, annot=True, fmt="d", cmap="Greens",
                xticklabels=class_names, yticklabels=class_names,
                ax=ax3, cbar=False)
    ax3.set_title("Confusion Matrix (Test Set)")
    ax3.set_xlabel("Predicted"); ax3.set_ylabel("True")
    plt.setp(ax3.get_xticklabels(), rotation=45, ha="right", fontsize=8)
    plt.setp(ax3.get_yticklabels(), rotation=0,  fontsize=8)

    plt.tight_layout()
    plot_path = save_dir / "training_report.png"
    plt.savefig(plot_path, dpi=150, bbox_inches="tight")
    print(f"📈  Training report saved: {plot_path}")

    # Classification report
    report = classification_report(y_true, y_pred, target_names=class_names)
    print("\nClassification Report:\n", report)
    (save_dir / "classification_report.txt").write_text(report)


# ─────────────────────────────────────────────
# Main training loop
# ─────────────────────────────────────────────
def train():
    print("=" * 60)
    print("  KrishakAI – Crop Disease Detection Model Training")
    print("=" * 60)

    if not SPLITS_DIR.exists():
        print(f"❌  Splits not found at {SPLITS_DIR}")
        print("    Run 01_download_and_prepare.py first.")
        sys.exit(1)

    train_ds, val_ds, test_ds, class_names, num_classes = load_datasets(SPLITS_DIR)
    model, base_model = build_model(num_classes)

    # ── Phase 1: Train head only ────────────────────────────────────────────
    print("\n🔥  Phase 1: Training classification head (base frozen) …")
    model.compile(
        optimizer=keras.optimizers.Adam(LR_INIT),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )
    model.summary(line_length=80)

    hist1 = model.fit(
        train_ds, epochs=EPOCHS,
        validation_data=val_ds,
        callbacks=get_callbacks(phase=1),
        verbose=1,
    )

    # ── Phase 2: Fine-tune top layers ───────────────────────────────────────
    print("\n🔧  Phase 2: Fine-tuning (top 50 layers of MobileNetV2) …")
    base_model.trainable = True
    # Only unfreeze the last ~50 layers
    for layer in base_model.layers[:-50]:
        layer.trainable = False

    model.compile(
        optimizer=keras.optimizers.Adam(LR_FINE),
        loss="categorical_crossentropy",
        metrics=["accuracy"],
    )

    hist2 = model.fit(
        train_ds, epochs=30,
        validation_data=val_ds,
        callbacks=get_callbacks(phase=2),
        verbose=1,
    )

    # ── Evaluate ─────────────────────────────────────────────────────────────
    print("\n🧪  Evaluating on test set …")
    test_loss, test_acc = model.evaluate(test_ds, verbose=1)
    print(f"\n✅  Test Accuracy : {test_acc * 100:.2f}%")
    print(f"    Test Loss     : {test_loss:.4f}")

    # Save final model
    final_path = str(MODEL_DIR / "crop_disease_model.keras")
    model.save(final_path)
    print(f"💾  Final model saved: {final_path}")

    # Save metadata
    meta = {
        "num_classes": num_classes,
        "class_names": class_names,
        "img_size": IMG_SIZE,
        "test_accuracy": float(test_acc),
        "test_loss": float(test_loss),
    }
    (MODEL_DIR / "model_metadata.json").write_text(json.dumps(meta, indent=2))

    # Plot
    plot_history([hist1, hist2], class_names, test_ds, model, LOGS_DIR)

    return model, class_names


if __name__ == "__main__":
    train()
