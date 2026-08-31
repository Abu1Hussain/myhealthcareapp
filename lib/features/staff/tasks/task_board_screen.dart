library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/staff/patients/patient_chart_screen.dart';

class TaskBoardScreen extends ConsumerStatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  ConsumerState<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends ConsumerState<TaskBoardScreen> {
  String _selectedStatus = 'Pending';
  bool _isPrioritizing = false;

  final List<String> _statusFilters = ['Pending', 'In Progress', 'Completed', 'All'];

  Future<void> _runAiPrioritization() async {
    final staff = ref.read(currentUserProvider);
    if (staff == null) return;

    setState(() => _isPrioritizing = true);

    final taskResult = await ref.read(taskRepositoryProvider).getTasksForStaff(staff.id);
    final tasks = taskResult.fold((l) => l, (_) => <StaffTaskItem>[]);

    if (tasks.isNotEmpty) {
      await ref.read(taskPrioritizationServiceProvider).prioritizeTasks(tasks);
    }

    if (!mounted) return;
    setState(() => _isPrioritizing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Clinical Prioritization updated with explainable rationales.')),
    );
  }

  Color _priorityColor(double blendedScore) {
    if (blendedScore >= 0.80) return AppColors.critical;
    if (blendedScore >= 0.60) return AppColors.warning;
    return AppColors.primaryTeal;
  }

  String _priorityLabel(double blendedScore) {
    if (blendedScore >= 0.80) return 'High';
    if (blendedScore >= 0.60) return 'Medium';
    return 'Routine';
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(currentUserProvider);
    if (staff == null) return const SizedBox.shrink();

    final tasksFuture = ref.watch(taskRepositoryProvider).getTasksForStaff(staff.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Task Board'),
        actions: [
          IconButton(
            tooltip: 'Re-prioritize with AI',
            icon: _isPrioritizing
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryTeal),
                  )
                : const Icon(Icons.auto_awesome_rounded, color: AppColors.aiAccent),
            onPressed: _isPrioritizing ? null : _runAiPrioritization,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
              child: Row(
                children: _statusFilters.map((s) {
                  final isSelected = _selectedStatus == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedStatus = s),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: FutureBuilder(
                future: tasksFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      itemCount: 4,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SkeletalShimmer(width: double.infinity, height: 110),
                      ),
                    );
                  }

                  var tasks = snapshot.data!.fold((l) => l, (_) => <StaffTaskItem>[]);

                  // Sort by blended priority descending
                  tasks.sort((a, b) => b.blendedPriority.compareTo(a.blendedPriority));

                  // Apply status filter
                  if (_selectedStatus == 'Pending') {
                    tasks = tasks.where((t) => t.status == TaskStatus.pending).toList();
                  } else if (_selectedStatus == 'In Progress') {
                    tasks = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
                  } else if (_selectedStatus == 'Completed') {
                    tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
                  }

                  if (tasks.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.task_alt_rounded,
                      title: 'All Caught Up!',
                      description: 'No clinical tasks found matching current filter.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final pColor = _priorityColor(task.blendedPriority);
                      final pLabel = _priorityLabel(task.blendedPriority);

                      return StaggeredFadeSlide(
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: DoubleBezelCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClinicalBadge(
                                      label: '$pLabel (${(task.blendedPriority * 100).round()}%)',
                                      backgroundColor: pColor.withValues(alpha: 0.15),
                                      textColor: pColor,
                                      pulsing: pLabel == 'High',
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Due: ${formatClinicalDate(task.dueAt)}',
                                      style: TextStyle(fontSize: 12, color: context.textSecondary),
                                    ),
                                    const Spacer(),
                                    _buildTaskStatusBadge(task.status),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  task.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                if (task.patientName != null || task.patientId != null) ...[
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: task.patientId != null
                                        ? () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => PatientChartScreen(patientId: task.patientId!),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      'Patient: ${task.patientName ?? "Patient #${task.patientId}"} ↗',
                                      style: const TextStyle(
                                        color: AppColors.primaryTeal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                                if (task.aiRationale != null && task.aiRationale!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.aiSurface,
                                      borderRadius: BorderRadius.circular(AppRadius.xs),
                                      border: Border.all(color: context.aiBorder),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.aiAccent),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            task.aiRationale!,
                                            style: TextStyle(fontSize: 11, color: context.textPrimary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (task.status == TaskStatus.pending) ...[
                                      TextButton(
                                        onPressed: () async {
                                          await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, TaskStatus.inProgress);
                                          setState(() {});
                                        },
                                        child: const Text('Start', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                    if (task.status != TaskStatus.completed) ...[
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, TaskStatus.completed);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.check_rounded, size: 16),
                                        label: const Text('Complete', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusBadge(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const ClinicalBadge(label: 'Pending');
      case TaskStatus.inProgress:
        return ClinicalBadge(label: 'In Progress', backgroundColor: AppColors.info.withValues(alpha: 0.15), textColor: AppColors.info);
      case TaskStatus.completed:
        return ClinicalBadge(label: 'Completed', backgroundColor: AppColors.success.withValues(alpha: 0.15), textColor: AppColors.success);
      case TaskStatus.dismissed:
        return const ClinicalBadge(label: 'Dismissed');
    }
  }
}
