"""
Synthetic Dataset Generator for Appointment No-Show Prediction (RQ2)
Generates 5,000 correlated clinical appointment samples with realistic Bahraini demographics.
"""

import numpy as np
import pandas as pd
from features import FEATURE_NAMES

def generate_synthetic_dataset(num_samples: int = 5000, random_state: int = 42) -> pd.DataFrame:
    np.random.seed(random_state)

    # 1. Patient Demographics & Baseline Characteristics
    age = np.clip(np.random.normal(loc=44, scale=18, size=num_samples), 18, 90).astype(int)

    # Chronic condition probability increases with age
    chronic_prob = 1.0 / (1.0 + np.exp(-(age - 45) / 12.0))
    has_chronic = (np.random.rand(num_samples) < chronic_prob).astype(int)

    # Medications correlated with chronic conditions
    num_meds = np.where(
        has_chronic == 1,
        np.random.poisson(lam=3.2, size=num_samples) + 1,
        np.random.poisson(lam=0.4, size=num_samples)
    )

    # Prior appointment history
    prior_completed = np.random.negative_binomial(n=3, p=0.4, size=num_samples)
    prior_no_shows = np.random.poisson(lam=0.8, size=num_samples)

    no_show_ratio = prior_no_shows / (prior_no_shows + prior_completed + 1.0)

    # Days since last visit (in days, max 365)
    days_since_last_visit = np.clip(np.random.exponential(scale=65, size=num_samples), 5, 365).astype(int)

    # 2. Appointment Scheduling Details
    lead_time_days = np.clip(np.random.exponential(scale=14, size=num_samples), 0, 90).astype(int)

    # Appointment Hour between 8 AM and 4 PM (8.0 to 16.0)
    appointment_hour = np.random.choice([8.0, 9.0, 10.0, 11.0, 13.0, 14.0, 15.0, 16.0], size=num_samples)
    is_morning = (appointment_hour < 12.0).astype(int)

    # Day of week in Bahrain (Sunday=0, Monday=1, Tuesday=2, Wednesday=3, Thursday=4)
    # Thursday & Sunday are weekend-adjacent
    day_of_week = np.random.choice([0, 1, 2, 3, 4], size=num_samples)
    is_weekend_adjacent = np.isin(day_of_week, [0, 4]).astype(int)

    # 3. Ground Truth No-Show Probability Formula (Latent Logistic Function)
    # Realistic weights based on clinical research:
    # - Higher lead time -> higher no show
    # - Higher prior no show ratio -> higher no show
    # - Younger age -> slightly higher no show
    # - Weekend adjacent & afternoon -> higher no show
    # - Chronic condition & more meds -> lower no show (higher adherence)
    latent_score = (
        -1.8
        + 0.045 * lead_time_days
        - 0.022 * (age - 40)
        + 3.2 * no_show_ratio
        + 0.45 * prior_no_shows
        - 0.55 * has_chronic
        - 0.12 * num_meds
        - 0.35 * is_morning
        + 0.42 * is_weekend_adjacent
        + 0.003 * days_since_last_visit
        + 0.08 * (appointment_hour - 12.0)
    )

    prob_no_show = 1.0 / (1.0 + np.exp(-latent_score))
    no_show_label = (np.random.rand(num_samples) < prob_no_show).astype(int)

    df = pd.DataFrame({
        "lead_time_days": lead_time_days,
        "age": age,
        "prior_no_shows": prior_no_shows,
        "prior_completed": prior_completed,
        "no_show_ratio": no_show_ratio,
        "has_chronic_condition": has_chronic,
        "num_medications": num_meds,
        "is_morning": is_morning,
        "is_weekend_adjacent": is_weekend_adjacent,
        "days_since_last_visit": days_since_last_visit,
        "appointment_hour": appointment_hour,
        "no_show": no_show_label,
    })

    return df

if __name__ == "__main__":
    df = generate_synthetic_dataset()
    df.to_csv("tools/ml/appointment_dataset.csv", index=False)
    print(f"Generated {len(df)} samples. No-show rate: {df['no_show'].mean():.2%}")
