library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Task Prioritization Engine blending deterministic rule scores with AI rationale (RQ3).
class TaskPrioritizationService {
  TaskPrioritizationService(this.ref);

  final Ref ref;

  /// Evaluates and prioritizes a list of staff tasks using a 40% Rule / 60% AI blended formula.
  /// Generates explainable natural-language clinical rationale for each task.
  Future<List<StaffTaskItem>> prioritizeTasks(List<StaffTaskItem> tasks) async {
    final updatedList = <StaffTaskItem>[];
    final taskRepo = ref.read(taskRepositoryProvider);

    for (final task in tasks) {
      if (task.status == TaskStatus.completed || task.status == TaskStatus.dismissed) {
        updatedList.add(task);
        continue;
      }

      final (aiScore, aiRationale) = _computeAiPriority(task);

      // Persist AI score and explainability rationale to database
      await taskRepo.updateTaskAiPriority(task.id, aiScore, aiRationale);

      updatedList.add(StaffTaskItem(
        id: task.id,
        staffId: task.staffId,
        patientId: task.patientId,
        title: task.title,
        kind: task.kind,
        dueAt: task.dueAt,
        status: task.status,
        ruleScore: task.ruleScore,
        aiPriorityScore: aiScore,
        aiRationale: aiRationale,
        createdAt: task.createdAt,
        patientName: task.patientName,
      ));
    }

    // Sort tasks in descending order of blended priority (highest first)
    updatedList.sort((a, b) => b.blendedPriority.compareTo(a.blendedPriority));
    return updatedList;
  }

  /// Calculates AI priority score and clinical explainability rationale.
  (double, String) _computeAiPriority(StaffTaskItem task) {
    final now = DateTime.now();
    final hoursUntilDue = task.dueAt.difference(now).inHours;
    final titleLower = task.title.toLowerCase();

    double baseAiScore = 0.50;
    String rationale = 'Standard priority clinical task.';

    switch (task.kind) {
      case TaskKind.reviewAbnormalLab:
        if (titleLower.contains('critical') || titleLower.contains('hypertensive') || titleLower.contains('hypoxia') || titleLower.contains('troponin')) {
          baseAiScore = 0.96;
          rationale = 'Urgent: Out-of-bounds critical biomarker requires immediate provider triage to prevent acute decompensation.';
        } else if (titleLower.contains('hba1c') || titleLower.contains('potassium') || titleLower.contains('hypertension')) {
          baseAiScore = 0.85;
          rationale = 'High: Uncontrolled metabolic or electrolyte parameter. Provider review recommended within 12 hours.';
        } else {
          baseAiScore = 0.72;
          rationale = 'Elevated: Abnormal laboratory finding requiring clinical correlation.';
        }
        break;

      case TaskKind.followUpOverdue:
      case TaskKind.patientOutreach:
        if (hoursUntilDue < 24) {
          baseAiScore = 0.78;
          rationale = 'High: Chronic disease patient overdue for comprehensive follow-up. Timely outreach reduces emergency utilization.';
        } else {
          baseAiScore = 0.60;
          rationale = 'Routine: Outpatient chronic care maintenance and appointment scheduling.';
        }
        break;

      case TaskKind.medicationRenewal:
        baseAiScore = 0.68;
        rationale = 'Moderate: Prescription renewal request pending physician authorization.';
        break;

      case TaskKind.signClinicalNote:
        baseAiScore = 0.55;
        rationale = 'Administrative: Unsigned encounter note requires final physician sign-off.';
        break;
    }

    // Adjust for due date urgency
    if (hoursUntilDue < 0) {
      baseAiScore = (baseAiScore + 0.15).clamp(0.0, 1.0);
      rationale = 'OVERDUE: $rationale';
    } else if (hoursUntilDue < 4) {
      baseAiScore = (baseAiScore + 0.08).clamp(0.0, 1.0);
      rationale = 'Due soon (<4h): $rationale';
    }

    return (baseAiScore, rationale);
  }
}

/// Provider for TaskPrioritizationService.
final taskPrioritizationServiceProvider = Provider<TaskPrioritizationService>((ref) {
  return TaskPrioritizationService(ref);
});
