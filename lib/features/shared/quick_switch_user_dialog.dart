library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

/// Quick Switch User Dialog for rapid live evaluation demos.
class QuickSwitchUserDialog extends ConsumerWidget {
  const QuickSwitchUserDialog({super.key});

  static const List<Map<String, String>> demoAccounts = [
    {
      'role': 'Patient (Asthma)',
      'name': 'Ali Mohamed Jaafar',
      'email': 'ali.jaafar@student.uob.bh',
      'pass': 'Patient123!',
    },
    {
      'role': 'Patient (Diabetes/HTN)',
      'name': 'Mohammed Meftah',
      'email': 'mohammed.meftah@student.uob.bh',
      'pass': 'Patient123!',
    },
    {
      'role': 'Doctor (Internal Med)',
      'name': 'Dr. Amal Ghanim',
      'email': 'amal.ghanim@myhealth.uob',
      'pass': 'Doctor123!',
    },
    {
      'role': 'Doctor (Cardiology)',
      'name': 'Dr. Reem Buallay',
      'email': 'reem.buallay@myhealth.uob',
      'pass': 'Doctor123!',
    },
    {
      'role': 'System Admin',
      'name': 'Admin User',
      'email': 'admin@myhealth.uob',
      'pass': 'Admin123!',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: DoubleBezelCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryTeal),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Quick Switch User (Demo)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Select a pre-seeded account to evaluate role features:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: demoAccounts.map((acc) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: context.surfaceElevated,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          side: BorderSide(color: context.borderColor),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                            child: Text(
                              acc['name']![0],
                              style: const TextStyle(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            acc['name']!,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary),
                          ),
                          subtitle: Text(
                            '${acc['role']} • ${acc['email']}',
                            style: TextStyle(fontSize: 11, color: context.textSecondary),
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            await ref
                                .read(authControllerProvider.notifier)
                                .switchDemoUser(acc['email']!, acc['pass']!);
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
