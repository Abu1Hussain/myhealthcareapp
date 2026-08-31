library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final medsFuture = ref.watch(vitalsRepositoryProvider).getMedicationsForPatient(user.id);

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
                  child: SkeletalShimmer(width: double.infinity, height: 80),
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

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final med = list[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: DoubleBezelCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryTealSurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.medication_rounded, color: AppColors.primaryTeal, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    med.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  const Spacer(),
                                  ClinicalBadge(
                                    label: med.isActive ? 'ACTIVE' : 'DISCONTINUED',
                                    backgroundColor: med.isActive ? const Color(0x2010B981) : const Color(0x2071717A),
                                    textColor: med.isActive ? AppColors.success : AppColors.textSecondaryLight,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Dose: ${med.dose} • ${med.frequency}',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Started ${med.startDate.day}/${med.startDate.month}/${med.startDate.year}',
                                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                              ),
                            ],
                          ),
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
    );
  }
}
