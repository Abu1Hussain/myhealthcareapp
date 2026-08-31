library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Clinical Rule Engine for automated patient risk detection & task escalation (RQ3).
class RiskDetectionService {
  RiskDetectionService(this.ref);

  final Ref ref;

  /// Evaluates a single vitals record and creates deduplicated risk flags and staff tasks if clinical thresholds are breached.
  Future<List<RiskFlagItem>> scanVitals({
    required int patientId,
    required VitalsRecord vitals,
    int? primaryStaffId,
  }) async {
    final generatedFlags = <RiskFlagItem>[];
    final riskRepo = ref.read(riskRepositoryProvider);
    final taskRepo = ref.read(taskRepositoryProvider);

    // Fetch existing unacknowledged flags for this patient to prevent duplicate alert storms
    final existingResult = await riskRepo.getActiveRiskFlags(patientId: patientId);
    final existingFlags = existingResult.fold(
      (list) => list.where((f) => f.acknowledgedAt == null).toList(),
      (_) => <RiskFlagItem>[],
    );
    final activeKinds = existingFlags.map((f) => f.kind).toSet();

    // 1. Blood Pressure: Hypertensive Crisis or Stage 2 Hypertension
    if (vitals.systolic != null && vitals.diastolic != null) {
      final sys = vitals.systolic!;
      final dia = vitals.diastolic!;

      if (sys >= 180 || dia >= 120) {
        if (!activeKinds.contains('hypertensive_crisis')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'hypertensive_crisis',
            severity: RiskSeverity.critical,
            rationale: 'Hypertensive Crisis: BP is ${sys.round()}/${dia.round()} mmHg (Threshold: ≥180/120). Immediate medical evaluation required.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      } else if (sys >= 140 || dia >= 90) {
        if (!activeKinds.contains('elevated_blood_pressure')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'elevated_blood_pressure',
            severity: RiskSeverity.high,
            rationale: 'Stage 2 Hypertension: BP is ${sys.round()}/${dia.round()} mmHg (Threshold: ≥140/90). Follow-up required.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      } else if (sys < 90) {
        if (!activeKinds.contains('hypotension')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'hypotension',
            severity: RiskSeverity.medium,
            rationale: 'Hypotension: Systolic BP is ${sys.round()} mmHg (<90 mmHg). Monitor for lightheadedness.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      }
    }

    // 2. Blood Glucose: Severe Hyperglycemia or Hypoglycemia
    if (vitals.glucose != null) {
      final gluc = vitals.glucose!;
      if (gluc < 70) {
        if (!activeKinds.contains('hypoglycemia')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'hypoglycemia',
            severity: RiskSeverity.critical,
            rationale: 'Critical Hypoglycemia: Blood glucose is ${gluc.round()} mg/dL (<70 mg/dL). Immediate glucose administration needed.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      } else if (gluc >= 250) {
        if (!activeKinds.contains('hyperglycemia_severe')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'hyperglycemia_severe',
            severity: RiskSeverity.high,
            rationale: 'Severe Hyperglycemia: Blood glucose is ${gluc.round()} mg/dL (≥250 mg/dL). Medication & ketone review required.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      }
    }

    // 3. Oxygen Saturation (SpO2): Hypoxia
    if (vitals.spo2 != null) {
      final spo2 = vitals.spo2!;
      if (spo2 < 90) {
        if (!activeKinds.contains('severe_hypoxia')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'severe_hypoxia',
            severity: RiskSeverity.critical,
            rationale: 'Severe Hypoxia: SpO2 is ${spo2.toStringAsFixed(1)}% (<90%). Supplemental oxygen & emergency assessment indicated.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      } else if (spo2 < 94) {
        if (!activeKinds.contains('mild_hypoxia')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'mild_hypoxia',
            severity: RiskSeverity.high,
            rationale: 'Mild Hypoxia: SpO2 is ${spo2.toStringAsFixed(1)}% (<94%). Clinical respiratory review recommended.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      }
    }

    // 4. Temperature: High Fever
    if (vitals.tempC != null && vitals.tempC! >= 38.5) {
      if (!activeKinds.contains('high_fever')) {
        final res = await riskRepo.createRiskFlag(
          patientId: patientId,
          kind: 'high_fever',
          severity: RiskSeverity.medium,
          rationale: 'High Fever: Body temperature is ${vitals.tempC!.toStringAsFixed(1)}°C (≥38.5°C). Investigate for acute infection.',
          source: RiskSource.deterministicRule,
        );
        res.fold(generatedFlags.add, (_) {});
      }
    }

    // Auto-generate high-priority clinical tasks for newly generated critical/high flags
    final assignedStaffId = primaryStaffId ?? 100; // Dr. Ahmed Al-Khalifa as default on-duty
    for (final flag in generatedFlags) {
      if (flag.severity == RiskSeverity.critical || flag.severity == RiskSeverity.high) {
        final ruleScore = flag.severity == RiskSeverity.critical ? 0.95 : 0.80;
        await taskRepo.createTask(
          staffId: assignedStaffId,
          patientId: patientId,
          title: 'Review ${flag.severity.name.toUpperCase()} Alert: ${flag.kind.replaceAll('_', ' ')}',
          kind: TaskKind.reviewAbnormalLab,
          dueAt: DateTime.now().add(flag.severity == RiskSeverity.critical ? const Duration(hours: 2) : const Duration(hours: 24)),
          ruleScore: ruleScore,
        );
      }
    }

    return generatedFlags;
  }

  /// Scans laboratory results for abnormal values and critical thresholds.
  Future<List<RiskFlagItem>> scanLabValues({
    required int patientId,
    required List<LabValue> labs,
    int? primaryStaffId,
  }) async {
    final generatedFlags = <RiskFlagItem>[];
    final riskRepo = ref.read(riskRepositoryProvider);
    final taskRepo = ref.read(taskRepositoryProvider);

    final existingResult = await riskRepo.getActiveRiskFlags(patientId: patientId);
    final existingFlags = existingResult.fold(
      (list) => list.where((f) => f.acknowledgedAt == null).toList(),
      (_) => <RiskFlagItem>[],
    );
    final activeKinds = existingFlags.map((f) => f.kind).toSet();

    for (final lab in labs) {
      final analyteLower = lab.analyte.toLowerCase();

      // Troponin (Cardiac biomarker)
      if (analyteLower.contains('troponin') && lab.value > 0.04) {
        if (!activeKinds.contains('elevated_troponin')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'elevated_troponin',
            severity: RiskSeverity.critical,
            rationale: 'Critical Troponin: ${lab.value} ${lab.unit} (Ref: <0.04). Immediate acute coronary syndrome evaluation required.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      }

      // HbA1c (Diabetes control)
      if (analyteLower.contains('hba1c') && lab.value >= 9.0) {
        if (!activeKinds.contains('poorly_controlled_hba1c')) {
          final res = await riskRepo.createRiskFlag(
            patientId: patientId,
            kind: 'poorly_controlled_hba1c',
            severity: RiskSeverity.high,
            rationale: 'Poorly Controlled Diabetes: HbA1c is ${lab.value}% (Target: <7.0%). Treatment intensification recommended.',
            source: RiskSource.deterministicRule,
          );
          res.fold(generatedFlags.add, (_) {});
        }
      }

      // Potassium (Electrolyte imbalance)
      if (analyteLower.contains('potassium') || analyteLower == 'k') {
        if (lab.value >= 5.5) {
          if (!activeKinds.contains('hyperkalemia')) {
            final res = await riskRepo.createRiskFlag(
              patientId: patientId,
              kind: 'hyperkalemia',
              severity: RiskSeverity.high,
              rationale: 'Hyperkalemia: Serum Potassium is ${lab.value} mmol/L (>5.5 mmol/L). Arrhythmia risk; review medications.',
              source: RiskSource.deterministicRule,
            );
            res.fold(generatedFlags.add, (_) {});
          }
        } else if (lab.value < 3.5) {
          if (!activeKinds.contains('hypokalemia')) {
            final res = await riskRepo.createRiskFlag(
              patientId: patientId,
              kind: 'hypokalemia',
              severity: RiskSeverity.medium,
              rationale: 'Hypokalemia: Serum Potassium is ${lab.value} mmol/L (<3.5 mmol/L). Electrolyte repletion indicated.',
              source: RiskSource.deterministicRule,
            );
            res.fold(generatedFlags.add, (_) {});
          }
        }
      }
    }

    // Generate tasks for critical/high lab flags
    final assignedStaffId = primaryStaffId ?? 100;
    for (final flag in generatedFlags) {
      if (flag.severity == RiskSeverity.critical || flag.severity == RiskSeverity.high) {
        final ruleScore = flag.severity == RiskSeverity.critical ? 0.95 : 0.85;
        await taskRepo.createTask(
          staffId: assignedStaffId,
          patientId: patientId,
          title: 'Review Abnormal Lab: ${flag.kind.replaceAll('_', ' ')}',
          kind: TaskKind.reviewAbnormalLab,
          dueAt: DateTime.now().add(const Duration(hours: 12)),
          ruleScore: ruleScore,
        );
      }
    }

    return generatedFlags;
  }

  /// Scans for chronic condition patients with overdue follow-ups (>180 days).
  Future<RiskFlagItem?> checkOverdueFollowUp({
    required int patientId,
    required List<String> chronicConditions,
    required DateTime? lastVisitDate,
    int? primaryStaffId,
  }) async {
    if (chronicConditions.isEmpty) return null;

    final now = DateTime.now();
    final daysSinceLast = lastVisitDate != null ? now.difference(lastVisitDate).inDays : 365;

    if (daysSinceLast > 180) {
      final riskRepo = ref.read(riskRepositoryProvider);
      final existingResult = await riskRepo.getActiveRiskFlags(patientId: patientId);
      final existing = existingResult.fold(
        (list) => list.any((f) => f.kind == 'overdue_chronic_followup' && f.acknowledgedAt == null),
        (_) => false,
      );

      if (!existing) {
        final res = await riskRepo.createRiskFlag(
          patientId: patientId,
          kind: 'overdue_chronic_followup',
          severity: RiskSeverity.medium,
          rationale: 'Overdue Follow-up: Patient with ${chronicConditions.join(', ')} has not had an encounter in $daysSinceLast days (>180 days).',
          source: RiskSource.deterministicRule,
        );

        return res.fold((flag) {
          ref.read(taskRepositoryProvider).createTask(
            staffId: primaryStaffId ?? 100,
            patientId: patientId,
            title: 'Outreach: Schedule chronic disease follow-up',
            kind: TaskKind.patientOutreach,
            dueAt: DateTime.now().add(const Duration(days: 3)),
            ruleScore: 0.65,
          );
          return flag;
        }, (_) => null);
      }
    }

    return null;
  }
}

/// Provider for RiskDetectionService.
final riskDetectionServiceProvider = Provider<RiskDetectionService>((ref) {
  return RiskDetectionService(ref);
});
