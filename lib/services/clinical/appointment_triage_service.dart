library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';

/// Clinical urgency tier for an appointment's stated reason for visit.
///
/// This is deliberately a *different* dimension from [RiskBand] (which
/// predicts no-show likelihood via the ML model): urgency answers "how
/// soon does this patient need to be seen", while no-show risk answers
/// "how likely are they to skip the visit". A patient can be simultaneously
/// low no-show risk and clinically urgent, or high no-show risk and
/// routine — conflating the two into one badge would hide that.
enum AppointmentUrgency { routine, priority, urgent }

extension AppointmentUrgencyPresentation on AppointmentUrgency {
  String get label {
    switch (this) {
      case AppointmentUrgency.routine:
        return 'Routine';
      case AppointmentUrgency.priority:
        return 'Priority';
      case AppointmentUrgency.urgent:
        return 'Urgent';
    }
  }

  /// Short clinical guidance shown alongside the tier.
  String get description {
    switch (this) {
      case AppointmentUrgency.routine:
        return 'Standard scheduling — no time-critical symptoms reported.';
      case AppointmentUrgency.priority:
        return 'Should be seen promptly — symptoms warrant closer attention.';
      case AppointmentUrgency.urgent:
        return 'Time-critical symptoms reported. If this is an emergency, call 999 or go to A&E now.';
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentUrgency.routine:
        return Icons.check_circle_outline_rounded;
      case AppointmentUrgency.priority:
        return Icons.priority_high_rounded;
      case AppointmentUrgency.urgent:
        return Icons.emergency_rounded;
    }
  }

  ClinicalTone get tone {
    switch (this) {
      case AppointmentUrgency.routine:
        return ClinicalTone.success;
      case AppointmentUrgency.priority:
        return ClinicalTone.warning;
      case AppointmentUrgency.urgent:
        return ClinicalTone.critical;
    }
  }

  /// Solid accent color (green/orange/red) for non-text uses — the card
  /// edge stripe, chart dots — where the AA-tuned badge-text shades from
  /// [ClinicalTone] would look washed out at full size.
  Color get accentColor {
    switch (this) {
      case AppointmentUrgency.routine:
        return AppColors.success;
      case AppointmentUrgency.priority:
        return AppColors.warning;
      case AppointmentUrgency.urgent:
        return AppColors.critical;
    }
  }
}

/// Deterministic, rule-based triage of an appointment's free-text reason
/// into an [AppointmentUrgency] tier. Runs entirely offline with no AI
/// dependency — mirrors [RiskDetectionService]'s "rules first" principle
/// so urgency badges are never blocked on model/network availability.
abstract final class AppointmentTriageService {
  static const List<String> _urgentKeywords = [
    'chest pain',
    'difficulty breathing',
    'shortness of breath',
    "can't breathe",
    'cannot breathe',
    'severe bleeding',
    'heavy bleeding',
    'unconscious',
    'unresponsive',
    'stroke',
    'seizure',
    'severe allergic',
    'anaphylaxis',
    'suicidal',
    'self harm',
    'severe pain',
    'overdose',
    'poisoning',
    'coughing blood',
    'blue lips',
    'head injury',
  ];

  static const List<String> _priorityKeywords = [
    'fever',
    'persistent pain',
    'infection',
    'vomiting',
    'dehydration',
    'swelling',
    'dizziness',
    'rash',
    'migraine',
    'moderate pain',
    'worsening',
    'not improving',
    'high blood pressure',
    'shortness',
    'fainting',
  ];

  static AppointmentUrgency classify(String reasonText) {
    final normalized = reasonText.toLowerCase();

    for (final keyword in _urgentKeywords) {
      if (normalized.contains(keyword)) return AppointmentUrgency.urgent;
    }
    for (final keyword in _priorityKeywords) {
      if (normalized.contains(keyword)) return AppointmentUrgency.priority;
    }
    return AppointmentUrgency.routine;
  }
}
