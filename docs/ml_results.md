# ML Appointment No-Show Prediction Evaluation (RQ2)

Evaluation results for the Senior Project IT Defense (University of Bahrain).

## 1. Model Performance vs. Baselines

| Model / Approach | Accuracy | Precision | Recall | F1-Score | ROC-AUC |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Logistic Regression (11 Features)** | **71.90%** | **56.40%** | **74.26%** | **64.11%** | **0.7977** |
| Lead Time Threshold (>14d) | 62.90% | 45.69% | 51.78% | 48.54% | 0.6210 |
| Majority Class Baseline | 66.20% | 0.00% | 0.00% | 0.00% | 0.5000 |

## 2. Feature Importance & Weights

| Feature | Coefficient (Weight) | Direction | Clinical Rationale |
| :--- | :--- | :--- | :--- |
| `lead_time_days` | `+0.5979` | Increases No-Show Risk | Normalized feature contribution |
| `age` | `-0.3280` | Decreases No-Show Risk | Normalized feature contribution |
| `prior_no_shows` | `+0.4891` | Increases No-Show Risk | Normalized feature contribution |
| `prior_completed` | `-0.0529` | Decreases No-Show Risk | Normalized feature contribution |
| `no_show_ratio` | `+0.4287` | Increases No-Show Risk | Normalized feature contribution |
| `has_chronic_condition` | `-0.3345` | Decreases No-Show Risk | Normalized feature contribution |
| `num_medications` | `-0.2476` | Decreases No-Show Risk | Normalized feature contribution |
| `is_morning` | `-0.2840` | Decreases No-Show Risk | Normalized feature contribution |
| `is_weekend_adjacent` | `+0.1739` | Increases No-Show Risk | Normalized feature contribution |
| `days_since_last_visit` | `+0.1435` | Increases No-Show Risk | Normalized feature contribution |
| `appointment_hour` | `+0.1297` | Increases No-Show Risk | Normalized feature contribution |
