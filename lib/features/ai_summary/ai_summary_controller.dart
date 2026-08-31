library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';

class AiSummaryState {
  const AiSummaryState({
    this.summary,
    this.isLoading = false,
    this.errorMessage,
  });

  final AiHealthSummary? summary;
  final bool isLoading;
  final String? errorMessage;
}

class AiSummaryController extends StateNotifier<AiSummaryState> {
  AiSummaryController(this.ref) : super(const AiSummaryState()) {
    loadSummary();
  }

  final Ref ref;

  Future<void> loadSummary({bool forceRefresh = false}) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = const AiSummaryState(isLoading: true);

    try {
      final activePatient = ref.read(managedDependentProvider) ?? user;
      final recordsResult = await ref.read(recordRepositoryProvider).getTimelineForPatient(activePatient.id, limit: 50);
      final vitalsResult = await ref.read(vitalsRepositoryProvider).getVitalsHistory(activePatient.id, limit: 30);
      final medsResult = await ref.read(vitalsRepositoryProvider).getMedicationsForPatient(activePatient.id);

      final records = recordsResult.fold((l) => l, (r) => <MedicalRecord>[]);
      final vitals = vitalsResult.fold((l) => l, (r) => <VitalsRecord>[]);
      final meds = medsResult.fold((l) => l, (r) => <Medication>[]);

      final cache = ref.read(aiResultCacheProvider);
      final summaryResult = await cache.getOrGenerateSummary(
        patient: activePatient,
        records: records,
        vitals: vitals,
        medications: meds,
        forceRefresh: forceRefresh,
      );

      summaryResult.fold(
        (summary) => state = AiSummaryState(summary: summary, isLoading: false),
        (failure) => state = AiSummaryState(isLoading: false, errorMessage: failure.message),
      );
    } catch (e) {
      state = AiSummaryState(isLoading: false, errorMessage: 'Failed to generate summary: $e');
    }
  }
}

final aiSummaryControllerProvider =
    StateNotifierProvider<AiSummaryController, AiSummaryState>((ref) {
  ref.watch(managedDependentProvider);
  return AiSummaryController(ref);
});
