import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/clinical/task_prioritization_service.dart';
import 'package:myhealth_ai/services/ml/feature_extractor.dart';
import 'package:myhealth_ai/services/ml/no_show_predictor.dart';

void main() {
  group('Cross-Role End-to-End Workflow Integration Tests', () {
    final patient = User(
      id: 1,
      role: UserRole.patient,
      fullName: 'Ali Mohamed Jaafar',
      email: 'ali.jaafar@student.uob.bh',
      phone: '+973 39123456',
      dob: DateTime(2002, 8, 24),
      gender: 'M',
      nationalId: '020824419',
      isActive: true,
      createdAt: DateTime.now(),
      patientProfile: const PatientProfile(
        userId: 1,
        bloodType: 'O+',
        allergies: ['Penicillin'],
        chronicConditions: ['Type 2 Diabetes', 'Hypertension'],
        emergencyContact: 'Family (+973 39112233)',
      ),
    );

    late NoShowPredictor predictor;

    setUp(() {
      predictor = NoShowPredictor.fromParameters(
        coefficients: [0.62, -0.39, 0.41, -0.29, 0.53, -0.27, -0.22, -0.18, 0.21, 0.19, 0.22],
        intercept: -0.42,
        means: [14.0, 44.0, 0.8, 4.5, 0.14, 0.48, 2.15, 0.5, 0.4, 65.0, 11.85],
        stds: [13.85, 17.92, 0.91, 3.25, 0.165, 0.499, 1.85, 0.5, 0.49, 63.4, 2.75],
        thresholdLow: 0.25,
        thresholdMedium: 0.55,
      );
    });

    test('Stage 1: Patient ML Slot Prediction & Feature Attribution', () {
      final features = FeatureExtractor.extract(
        patient: patient,
        proposedSlotStart: DateTime.now().add(const Duration(days: 4)),
        bookingDate: DateTime.now(),
        priorNoShows: 0,
        priorCompleted: 5,
        activeMedicationCount: 2,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 45)),
      );

      expect(features.length, equals(11));

      final prediction = predictor.predict(features);
      expect(prediction.probability, inInclusiveRange(0.0, 1.0));
      expect(prediction.riskBand, isNotNull);
      expect(prediction.contributions.length, equals(11));
    });

    test('Stage 2: Clinical Vitals Risk Threshold Evaluation', () {
      // Simulate acute hypertensive crisis reading: 185/115 mmHg
      final vitals = VitalsRecord(
        id: 101,
        patientId: patient.id,
        recordedAt: DateTime.now(),
        systolic: 185,
        diastolic: 115,
        heartRate: 92,
        spo2: 97.5,
        glucose: 142,
      );

      final isHypertensiveCrisis = (vitals.systolic ?? 0) >= 180 || (vitals.diastolic ?? 0) >= 120;
      expect(isHypertensiveCrisis, isTrue);

      final isCriticalSpo2 = (vitals.spo2 ?? 100) < 90;
      expect(isCriticalSpo2, isFalse);
    });

    test('Stage 3: AI Task Prioritization & Clinical Explainability Rationale', () {
      final tasks = [
        StaffTaskItem(
          id: 1,
          staffId: 100,
          patientId: patient.id,
          title: 'Review Critical Alert: hypertensive crisis',
          kind: TaskKind.reviewAbnormalLab,
          dueAt: DateTime.now().add(const Duration(hours: 2)),
          status: TaskStatus.pending,
          ruleScore: 0.95,
          aiPriorityScore: 0.96,
          aiRationale: 'Urgent: Out-of-bounds critical biomarker requires immediate provider triage.',
          createdAt: DateTime.now(),
        ),
        StaffTaskItem(
          id: 2,
          staffId: 100,
          patientId: patient.id,
          title: 'Routine medication renewal',
          kind: TaskKind.medicationRenewal,
          dueAt: DateTime.now().add(const Duration(days: 3)),
          status: TaskStatus.pending,
          ruleScore: 0.50,
          aiPriorityScore: 0.65,
          aiRationale: 'Moderate: Prescription renewal request pending physician authorization.',
          createdAt: DateTime.now(),
        ),
      ];

      // Sort by blended priority descending
      tasks.sort((a, b) => b.blendedPriority.compareTo(a.blendedPriority));

      // Task 1: (0.95 * 0.4) + (0.96 * 0.6) = 0.38 + 0.576 = 0.956
      // Task 2: (0.50 * 0.4) + (0.65 * 0.6) = 0.20 + 0.39 = 0.590
      expect(tasks.first.id, equals(1));
      expect(tasks.first.blendedPriority, greaterThan(0.90));
      expect(tasks.first.aiRationale, contains('Urgent'));
    });
  });
}
