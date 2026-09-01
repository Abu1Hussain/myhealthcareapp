library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

/// The audit trail.
///
/// The previous screen mapped six colours onto action types — teal for a
/// note, amber for a prescription, green for an acknowledgement — which
/// implied a ranking that does not exist. A log is a log: time in the
/// margin, action, entity, actor. Reading order does the work.
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

  /// 'ACKNOWLEDGE_RISK_FLAG' reads as 'Acknowledge risk flag'.
  String _humanAction(String action) {
    final words = action.toLowerCase().split(RegExp(r'[_\s]+'));
    if (words.isEmpty) return action;
    final first = words.first;
    return [
      first.isEmpty ? first : '${first[0].toUpperCase()}${first.substring(1)}',
      ...words.skip(1),
    ].join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = _filterController.text.trim().toLowerCase();
    final auditFuture = ref.watch(adminRepositoryProvider).getAuditLogs(limit: 100);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Administration'),
                  const SizedBox(height: 6),
                  Text(
                    'Audit trail',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 30,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The last 100 recorded actions, newest first.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _filterController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Filter by action, entity or actor',
                      prefixIcon: const Icon(Icons.filter_list_rounded, size: 19),
                      suffixIcon: filter.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () => setState(_filterController.clear),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: auditFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: 8,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SkeletalShimmer(width: double.infinity, height: 52),
                      ),
                    );
                  }

                  var logs = snapshot.data!.fold((l) => l, (_) => <AuditEntry>[]);

                  if (filter.isNotEmpty) {
                    logs = logs
                        .where((l) =>
                            l.action.toLowerCase().contains(filter) ||
                            l.entityType.toLowerCase().contains(filter) ||
                            (l.actorName?.toLowerCase().contains(filter) ?? false))
                        .toList();
                  }

                  if (logs.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      title: filter.isEmpty ? 'Nothing logged yet' : 'No match',
                      description: filter.isEmpty
                          ? 'Sign-ins, clinical notes, prescriptions and '
                              'acknowledgements are recorded here as they happen.'
                          : 'No entry matches "${_filterController.text.trim()}".',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl,
                    ),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final entry = logs[index];
                      final previous = index == 0 ? null : logs[index - 1];
                      final newDay = previous == null ||
                          previous.timestamp.day != entry.timestamp.day ||
                          previous.timestamp.month != entry.timestamp.month;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (newDay) ...[
                            SizedBox(height: index == 0 ? 0 : AppSpacing.lg),
                            Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: theme.colorScheme.onSurface),
                                ),
                              ),
                              child: Eyebrow(formatClinicalDate(entry.timestamp)),
                            ),
                          ],
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 52,
                                  child: Text(
                                    formatTime24h(entry.timestamp),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _humanAction(entry.action),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        '${entry.entityType}'
                                        '${entry.entityId != null ? ' #${entry.entityId}' : ''}'
                                        ' · ${entry.actorName ?? 'user #${entry.actorUserId ?? 'system'}'}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontFeatures: const [FontFeature.tabularFigures()],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const RowRule(),
                        ],
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
