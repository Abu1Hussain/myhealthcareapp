library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final profile = user.patientProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar Card
              DoubleBezelCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                      child: Text(
                        user.fullName[0],
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phone: ${user.phone}',
                            style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Clinical Data Details Card
              if (profile != null) ...[
                Text(
                  'Clinical Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DoubleBezelCard(
                  child: Column(
                    children: [
                      _ProfileRow(label: 'National CPR ID', value: user.nationalId),
                      const Divider(),
                      _ProfileRow(label: 'Blood Group', value: profile.bloodType),
                      const Divider(),
                      _ProfileRow(
                        label: 'Chronic Conditions',
                        value: profile.chronicConditions.isEmpty ? 'None on record' : profile.chronicConditions.join(', '),
                      ),
                      const Divider(),
                      _ProfileRow(
                        label: 'Known Allergies',
                        value: profile.allergies.isEmpty ? 'No known allergies' : profile.allergies.join(', '),
                      ),
                      const Divider(),
                      _ProfileRow(label: 'Emergency Contact', value: profile.emergencyContact),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // System Preferences & Actions
              Text(
                'Account & Evaluation Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DoubleBezelCard(
                padding: EdgeInsets.zero,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryTeal),
                        title: const Text('Quick Switch Demo User'),
                        subtitle: const Text('Evaluate Doctor or Admin views'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const QuickSwitchUserDialog(),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: AppColors.critical),
                        title: const Text('Sign Out', style: TextStyle(color: AppColors.critical, fontWeight: FontWeight.w600)),
                        onTap: () => ref.read(authControllerProvider.notifier).logout(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
