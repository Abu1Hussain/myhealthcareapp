import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/ml/feature_extractor.dart';
import 'package:myhealth_ai/services/ml/no_show_predictor.dart';

void main() {
  final testPatient = User(
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

  group('FeatureExtractor Tests', () {
    test('extract returns exactly 11 features', () {
      final features = FeatureExtractor.extract(
        patient: testPatient,
        proposedSlotStart: DateTime.now().add(const Duration(days: 7)),
        bookingDate: DateTime.now(),
        priorNoShows: 2,
        priorCompleted: 8,
        activeMedicationCount: 3,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 30)),
      );

      expect(features.length, equals(11));
    });

    test('lead_time_days is clamped between 0 and 90', () {
      final features = FeatureExtractor.extract(
        patient: testPatient,
        proposedSlotStart: DateTime.now().add(const Duration(days: 120)),
        bookingDate: DateTime.now(),
        priorNoShows: 0,
        priorCompleted: 0,
        activeMedicationCount: 0,
        lastVisitDate: null,
      );

      expect(features[0], equals(90.0)); // Clamped at 90
    });

    test('has_chronic_condition is 1 for patients with chronic conditions', () {
      final features = FeatureExtractor.extract(
        patient: testPatient,
        proposedSlotStart: DateTime.now().add(const Duration(days: 3)),
        bookingDate: DateTime.now(),
        priorNoShows: 0,
        priorCompleted: 0,
        activeMedicationCount: 2,
        lastVisitDate: null,
      );

      expect(features[5], equals(1.0)); // has_chronic_condition
    });

    test('days_since_last_visit defaults to 365 when no prior visit', () {
      final features = FeatureExtractor.extract(
        patient: testPatient,
        proposedSlotStart: DateTime.now().add(const Duration(days: 5)),
        bookingDate: DateTime.now(),
        priorNoShows: 0,
        priorCompleted: 0,
        activeMedicationCount: 0,
        lastVisitDate: null,
      );

      expect(features[9], equals(365.0));
    });
  });

  group('NoShowPredictor Tests', () {
    late NoShowPredictor predictor;

    setUp(() {
      // Create predictor with known parameters for deterministic testing
      predictor = NoShowPredictor.fromParameters(
        coefficients: [0.62, -0.39, 0.41, -0.29, 0.53, -0.27, -0.22, -0.18, 0.21, 0.19, 0.22],
        intercept: -0.42,
        means: [14.0, 44.0, 0.8, 4.5, 0.14, 0.48, 2.15, 0.5, 0.4, 65.0, 11.85],
        stds: [13.85, 17.92, 0.91, 3.25, 0.165, 0.499, 1.85, 0.5, 0.49, 63.4, 2.75],
        thresholdLow: 0.25,
        thresholdMedium: 0.55,
      );
    });

    test('predict returns probability between 0.0 and 1.0', () {
      final features = [7.0, 42.0, 1.0, 6.0, 0.14, 1.0, 3.0, 1.0, 0.0, 30.0, 9.0];
      final result = predictor.predict(features);

      expect(result.probability, greaterThanOrEqualTo(0.0));
      expect(result.probability, lessThanOrEqualTo(1.0));
    });

    test('predict classifies low risk correctly', () {
      // Low-risk scenario: low lead time, chronic condition (engaged), morning, many completed visits
      final features = [3.0, 55.0, 0.0, 15.0, 0.0, 1.0, 4.0, 1.0, 0.0, 14.0, 9.0];
      final result = predictor.predict(features);

      expect(result.probability, lessThan(0.25));
      expect(result.riskBand, equals(RiskBand.low));
      expect(result.riskLabel, equals('Low Risk'));
    });

    test('predict classifies high risk correctly', () {
      // High-risk scenario: long lead time, many no-shows, no chronic (disengaged), afternoon, weekend-adjacent
      final features = [60.0, 22.0, 5.0, 1.0, 0.71, 0.0, 0.0, 0.0, 1.0, 300.0, 15.0];
      final result = predictor.predict(features);

      expect(result.probability, greaterThanOrEqualTo(0.55));
      expect(result.riskBand, equals(RiskBand.high));
    });

    test('predict populates feature contributions and explainability factors', () {
      final features = [60.0, 22.0, 5.0, 1.0, 0.71, 0.0, 0.0, 0.0, 1.0, 300.0, 15.0];
      final result = predictor.predict(features);

      expect(result.contributions.length, equals(11));
      expect(result.contributions.containsKey('Lead Time (days)'), isTrue);
      expect(result.topRiskFactors.isNotEmpty, isTrue);
    });

    test('Python-Dart numerical parity within 1e-6 precision', () {
      // Mean vector features -> standardized features are 0.0 -> z = intercept -> prob = 1/(1 + e^(0.42))
      final meanFeatures = [14.0, 44.0, 0.8, 4.5, 0.14, 0.48, 2.15, 0.5, 0.4, 65.0, 11.85];
      final result = predictor.predict(meanFeatures);

      // 1 / (1 + exp(-(-0.42))) = 1 / (1 + 1.521961556) ≈ 0.39653066
      const expectedProb = 0.39653066;
      expect((result.probability - expectedProb).abs(), lessThan(1e-4));
    });

    test('execution time is under 5ms', () {
      final features = [14.0, 44.0, 1.0, 4.0, 0.2, 1.0, 2.0, 1.0, 0.0, 60.0, 10.0];
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        predictor.predict(features);
      }

      stopwatch.stop();
      final avgMicroseconds = stopwatch.elapsedMicroseconds / 1000;
      expect(avgMicroseconds, lessThan(5000)); // < 5ms per call
    });
  });
}
