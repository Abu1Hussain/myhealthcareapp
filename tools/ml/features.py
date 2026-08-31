"""
11 Feature Definitions for Appointment No-Show Prediction (RQ2)
"""

FEATURE_NAMES = [
    "lead_time_days",         # f0: Days between booking and appointment
    "age",                    # f1: Patient age in years
    "prior_no_shows",         # f2: Number of previous missed appointments
    "prior_completed",        # f3: Number of previous attended appointments
    "no_show_ratio",          # f4: Historical no-show rate: no_shows / (no_shows + completed + 1)
    "has_chronic_condition",   # f5: 1 if patient has diabetes/hypertension/etc., 0 otherwise
    "num_medications",        # f6: Number of active medications
    "is_morning",             # f7: 1 if appointment is before 12:00 PM, 0 otherwise
    "is_weekend_adjacent",    # f8: 1 if appointment is on Thursday or Sunday (Bahrain work week)
    "days_since_last_visit",  # f9: Recency in days (capped at 365)
    "appointment_hour",       # f10: Hour of the day (e.g. 8.0 to 16.0)
]
