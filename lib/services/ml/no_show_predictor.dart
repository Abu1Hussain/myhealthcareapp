library;

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:myhealth_ai/domain/entities/models.dart' show RiskBand;

/// Result of a no-show prediction including probability, risk band, and feature contributions.
class NoShowPrediction {
  const NoShowPrediction({
    required this.probability,
    required this.riskBand,
    required this.features,
    required this.contributions,
  });

  /// Predicted probability of no-show P ∈ [0.0, 1.0].
  final double probability;

  /// Categorical risk classification.
  final RiskBand riskBand;

  /// The raw 11-element feature vector used for this prediction.
  final List<double> features;

  /// Per-feature contribution score: w_i * (x_i - mean_i) / std_i.
  final Map<String, double> contributions;

  /// Human-readable risk label.
  String get riskLabel {
    switch (riskBand) {
      case RiskBand.low:
        return 'Low Risk';
      case RiskBand.medium:
        return 'Medium Risk';
      case RiskBand.high:
        return 'High Risk';
    }
  }

  /// Percentage string (e.g. "34%").
  String get percentageLabel => '${(probability * 100).round()}%';

  /// Top risk-increasing factors (positive contribution).
  List<MapEntry<String, double>> get topRiskFactors {
    final sorted = contributions.entries.where((e) => e.value > 0.05).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).toList();
  }

  /// Top protective factors (negative contribution).
  List<MapEntry<String, double>> get topProtectiveFactors {
    final sorted = contributions.entries.where((e) => e.value < -0.05).toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sorted.take(3).toList();
  }
}

/// Pure-Dart offline logistic regression inference engine (RQ2).
///
/// Loads exported model weights from `assets/models/no_show_model.json`
/// and performs <1ms sigmoid inference on device without Python runtime.
class NoShowPredictor {
  NoShowPredictor._({
    required this.coefficients,
    required this.intercept,
    required this.means,
    required this.stds,
    required this.thresholdLow,
    required this.thresholdMedium,
    required this.version,
  });

  /// Creates a predictor from raw parameters (useful for testing).
  factory NoShowPredictor.fromParameters({
    required List<double> coefficients,
    required double intercept,
    required List<double> means,
    required List<double> stds,
    double thresholdLow = 0.25,
    double thresholdMedium = 0.55,
    String version = '1.0.0',
  }) {
    return NoShowPredictor._(
      coefficients: coefficients,
      intercept: intercept,
      means: means,
      stds: stds,
      thresholdLow: thresholdLow,
      thresholdMedium: thresholdMedium,
      version: version,
    );
  }

  final List<double> coefficients;
  final double intercept;
  final List<double> means;
  final List<double> stds;
  final double thresholdLow;
  final double thresholdMedium;
  final String version;

  static NoShowPredictor? _instance;

  /// Loads model from bundled asset. Cached after first load.
  static Future<NoShowPredictor> load() async {
    if (_instance != null) return _instance!;

    final jsonStr = await rootBundle.loadString('assets/models/no_show_model.json');
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    final coefficients = (data['coefficients'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    final means = (data['means'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    final stds = (data['stds'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    final thresholds = data['thresholds'] as Map<String, dynamic>;

    _instance = NoShowPredictor._(
      coefficients: coefficients,
      intercept: (data['intercept'] as num).toDouble(),
      means: means,
      stds: stds,
      thresholdLow: (thresholds['low'] as num).toDouble(),
      thresholdMedium: (thresholds['medium'] as num).toDouble(),
      version: data['version']?.toString() ?? '1.0.0',
    );

    return _instance!;
  }

  static const List<String> featureNames = [
    'Lead Time (days)',
    'Patient Age',
    'Prior No-Shows',
    'Prior Completed Visits',
    'Historical No-Show Ratio',
    'Has Chronic Condition',
    'Active Medications Count',
    'Morning Time Slot',
    'Weekend-Adjacent Day',
    'Days Since Last Visit',
    'Appointment Hour',
  ];

  /// Predicts the no-show probability for a given 11-element feature vector.
  ///
  /// Steps:
  /// 1. Standardize: x_scaled[i] = (x[i] - mean[i]) / std[i]
  /// 2. Dot product: z = intercept + Σ(coeff[i] * x_scaled[i])
  /// 3. Sigmoid: P = 1 / (1 + e^(-z))
  /// 4. Classify: Low (<0.25), Medium (0.25–0.55), High (≥0.55)
  NoShowPrediction predict(List<double> features) {
    assert(features.length == coefficients.length,
        'Feature vector length ${features.length} != model expects ${coefficients.length}');

    // 1. Standardize features & calculate per-feature contributions
    double z = intercept;
    final contributions = <String, double>{};
    for (int i = 0; i < features.length; i++) {
      final stdVal = stds[i] != 0.0 ? stds[i] : 1.0;
      final xScaled = (features[i] - means[i]) / stdVal;
      final contribution = coefficients[i] * xScaled;
      z += contribution;
      final name = i < featureNames.length ? featureNames[i] : 'f$i';
      contributions[name] = contribution;
    }

    // 2. Sigmoid activation
    final probability = 1.0 / (1.0 + math.exp(-z));

    // 3. Risk band classification
    final RiskBand band;
    if (probability < thresholdLow) {
      band = RiskBand.low;
    } else if (probability < thresholdMedium) {
      band = RiskBand.medium;
    } else {
      band = RiskBand.high;
    }

    return NoShowPrediction(
      probability: probability,
      riskBand: band,
      features: features,
      contributions: contributions,
    );
  }
}
