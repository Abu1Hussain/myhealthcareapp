library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';

class TimelineState {
  const TimelineState({
    this.records = const [],
    this.isLoading = false,
    this.selectedType,
    this.searchQuery = '',
    this.errorMessage,
  });

  final List<MedicalRecord> records;
  final bool isLoading;
  final RecordType? selectedType;
  final String searchQuery;
  final String? errorMessage;

  TimelineState copyWith({
    List<MedicalRecord>? records,
    bool? isLoading,
    RecordType? selectedType,
    bool clearType = false,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TimelineState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TimelineController extends StateNotifier<TimelineState> {
  TimelineController(this.ref) : super(const TimelineState()) {
    loadTimeline();
  }

  final Ref ref;

  Future<void> loadTimeline() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final patientId = ref.read(managedDependentProvider)?.id ?? user.id;
    final recordRepo = ref.read(recordRepositoryProvider);
    final result = await recordRepo.getTimelineForPatient(
      patientId,
      filterType: state.selectedType,
      searchQuery: state.searchQuery,
      limit: 100,
    );

    result.fold(
      (list) => state = state.copyWith(records: list, isLoading: false),
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  void selectType(RecordType? type) {
    if (state.selectedType == type) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(selectedType: type);
    }
    loadTimeline();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    loadTimeline();
  }
}

final timelineControllerProvider =
    StateNotifierProvider<TimelineController, TimelineState>((ref) {
  // Reconstruct (and reload) whenever the guardian switches between their
  // own record and a managed dependent's.
  ref.watch(managedDependentProvider);
  return TimelineController(ref);
});
