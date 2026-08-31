library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class DepartmentScheduleScreen extends ConsumerWidget {
  const DepartmentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deptsFuture = ref.watch(userRepositoryProvider).getDepartments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments & Clinic Schedules'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: deptsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: 4,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SkeletalShimmer(width: double.infinity, height: 100),
                ),
              );
            }

            final depts = snapshot.data!.fold((l) => l, (_) => <Department>[]);

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: depts.length,
              itemBuilder: (context, index) {
                final dept = depts[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: DoubleBezelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.apartment_rounded, color: AppColors.primaryTeal, size: 20),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(dept.description, style: TextStyle(color: context.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Text(
                          'Weekly Clinic Availability: Sun – Thu • 08:00 – 16:00 (30-min slots)',
                          style: TextStyle(color: context.textSecondary, fontSize: 12),
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
