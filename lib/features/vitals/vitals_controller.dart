library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';

class VitalsState {
  const VitalsState({
    this.vitals = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<VitalsRecord> vitals;
  final bool isLoading;
  final String? errorMessage;
}

class VitalsController extends StateNotifier<VitalsState> {
  VitalsController(this.ref) : super(const VitalsState()) {
    loadVitals();
  }

  final Ref ref;

  Future<void> loadVitals() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = const VitalsState(isLoading: true);

    final result = await ref.read(vitalsRepositoryProvider).getVitalsHistory(user.id, limit: 50);

    result.fold(
      (list) => state = VitalsState(vitals: list, isLoading: false),
      (failure) => state = VitalsState(isLoading: false, errorMessage: failure.message),
    );
  }

  Future<bool> logVitals({
    double? systolic,
    double? diastolic,
    double? heartRate,
    double? tempC,
    double? weightKg,
    double? heightCm,
    double? spo2,
    double? glucose,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return false;

    final result = await ref.read(vitalsRepositoryProvider).logVitals(
          patientId: user.id,
          recordedAt: DateTime.now(),
          systolic: systolic,
          diastolic: diastolic,
          heartRate: heartRate,
          tempC: tempC,
          weightKg: weightKg,
          heightCm: heightCm,
          spo2: spo2,
          glucose: glucose,
        );

    return result.fold(
      (v) {
        loadVitals();
        return true;
      },
      (f) => false,
    );
  }
}

final vitalsControllerProvider =
    StateNotifierProvider<VitalsController, VitalsState>((ref) {
  return VitalsController(ref);
});
