library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  String _timeHint(String frequency) {
    final f = frequency.toLowerCase();
    if (f.contains('bedtime')) return '22:30';
    if (f.contains('evening')) return '21:00';
    if (f.contains('morning')) return '08:00';
    if (f.contains('empty stomach')) return '07:00';
    if (f.contains('twice')) return '08:00 · 20:00';
    if (f.contains('needed')) return 'as needed';
    return '—';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final patientId = effectivePatientId(ref, user);
    final medsFuture = ref.watch(vitalsRepositoryProvider).getMedicationsForPatient(patientId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: medsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: 4,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: SkeletalShimmer(width: double.infinity, height: 72),
                ),
              );
            }

            final list = snapshot.data!.fold((l) => l, (r) => <Medication>[]);

            if (list.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.medication_outlined,
                title: 'No Medications on Record',
                description: 'Prescribed medications will automatically sync from your consultation records.',
              );
            }

            final active = list.where((m) => m.isActive).toList();
            final past = list.where((m) => !m.isActive).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (active.isNotEmpty) ...[
                    SectionHead(
                      title: 'Active Prescriptions',
                      trailing: Text(
                        '${active.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    for (final med in active) _MedRow(med: med, timeHint: _timeHint(med.frequency)),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  if (past.isNotEmpty) ...[
                    SectionHead(
                      title: 'Past / Discontinued',
                      trailing: Text(
                        '${past.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    for (final med in past) _MedRow(med: med, timeHint: _timeHint(med.frequency)),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MedRow extends StatelessWidget {
  const _MedRow({required this.med, required this.timeHint});

  final Medication med;
  final String timeHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 78,
                child: Text(
                  timeHint,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${med.name} ${med.dose}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ClinicalBadge(
                          label: med.isActive ? 'Active' : 'Discontinued',
                          tone: med.isActive ? ClinicalTone.primary : ClinicalTone.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(med.frequency, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      'Prescribed on ${formatClinicalDate(med.startDate)}'
                      '${med.endDate != null ? ' · Ended ${formatClinicalDate(med.endDate!)}' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
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
  }
}
