library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  final _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Color _actionColor(String action) {
    switch (action.toUpperCase()) {
      case 'LOGIN':
        return AppColors.info;
      case 'CREATE_NOTE':
      case 'ADD_CLINICAL_NOTE':
        return AppColors.primaryTeal;
      case 'PRESCRIBE_MEDICATION':
        return AppColors.warning;
      case 'ACKNOWLEDGE_RISK_FLAG':
        return AppColors.success;
      case 'BOOK_APPOINTMENT':
        return AppColors.info;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auditFuture = ref.watch(adminRepositoryProvider).getAuditLogs(limit: 100);
    final filter = _filterController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Audit Trail & Governance'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Filter by action, entity, or actor...',
                  prefixIcon: const Icon(Icons.filter_list_rounded),
                  suffixIcon: filter.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => setState(() => _filterController.clear()),
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: auditFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                      itemCount: 8,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.xs),
                        child: SkeletalShimmer(width: double.infinity, height: 65),
                      ),
                    );
                  }

                  var logs = snapshot.data!.fold((l) => l, (_) => <AuditEntry>[]);

                  if (filter.isNotEmpty) {
                    logs = logs.where((l) =>
                        l.action.toLowerCase().contains(filter) ||
                        l.entityType.toLowerCase().contains(filter) ||
                        (l.actorName?.toLowerCase().contains(filter) ?? false)).toList();
                  }

                  if (logs.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.history_rounded,
                      title: 'No Audit Entries',
                      description: 'No matching audit logs found.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final entry = logs[index];
                      final color = _actionColor(entry.action);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: DoubleBezelCard(
                          child: Row(
                            children: [
                              ClinicalBadge(
                                label: entry.action,
                                backgroundColor: color.withValues(alpha: 0.15),
                                textColor: color,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${entry.entityType} ${entry.entityId != null ? "#${entry.entityId}" : ""}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      'Actor: ${entry.actorName ?? "User #${entry.actorUserId ?? 'Sys'}"}',
                                      style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${formatClinicalDate(entry.timestamp)} ${formatTime24h(entry.timestamp)}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                              ),
                            ],
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
}
