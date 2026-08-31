"""
Train Logistic Regression Model for Appointment No-Show Prediction (RQ2)
Exports model weights and scaler statistics to assets/models/no_show_model.json
"""

import json
import os
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from generate_dataset import generate_synthetic_dataset
from features import FEATURE_NAMES

def train_and_export():
    df = generate_synthetic_dataset(num_samples=5000, random_state=42)

    X = df[FEATURE_NAMES]
    y = df["no_show"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)

    clf = LogisticRegression(class_weight="balanced", random_state=42, max_iter=1000)
    clf.fit(X_train_scaled, y_train)

    os.makedirs("assets/models", exist_ok=True)

    model_payload = {
        "model_type": "logistic_regression",
        "version": "1.0.0",
        "target": "no_show",
        "feature_names": FEATURE_NAMES,
        "means": scaler.mean_.tolist(),
        "stds": scaler.scale_.tolist(),
        "coefficients": clf.coef_[0].tolist(),
        "intercept": float(clf.intercept_[0]),
        "thresholds": {
            "low": 0.25,
            "medium": 0.55,
        },
        "metrics_summary": {
            "training_samples": len(X_train),
            "test_samples": len(X_test),
            "class_ratio": float(y.mean()),
        }
    }

    output_path = "assets/models/no_show_model.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(model_payload, f, indent=2)

    print(f"Model exported successfully to {output_path}")
    print(f"Intercept: {clf.intercept_[0]:.4f}")
    for name, coef in zip(FEATURE_NAMES, clf.coef_[0]):
        print(f"  {name:22s}: {coef:+.4f}")

if __name__ == "__main__":
    train_and_export()
