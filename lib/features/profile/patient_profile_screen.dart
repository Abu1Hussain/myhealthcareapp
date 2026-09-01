library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/auth/switch_account_sheet.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/family_section.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guardian = ref.watch(currentUserProvider);
    if (guardian == null) return const SizedBox.shrink();

    final managedDependent = ref.watch(managedDependentProvider);
    final displayedUser = managedDependent ?? guardian;
    final displayedProfile = displayedUser.patientProfile;
    final isManaging = managedDependent != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isManaging ? "${displayedUser.fullName}'s Profile" : 'Profile & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ManagingDependentBanner(),
              if (isManaging) const SizedBox(height: AppSpacing.lg),

              // Active Profile Card
              DoubleBezelCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.accent900 : AppColors.accent100,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        displayedUser.fullName.isNotEmpty ? displayedUser.fullName[0] : 'P',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.accent300 : AppColors.accent800,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayedUser.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isManaging ? 'Age ${displayedUser.age}' : displayedUser.email,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          if (!isManaging && displayedUser.phone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Phone: ${displayedUser.phone}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Clinical Data Details Card
              if (displayedProfile != null) ...[
                const SectionHead(title: 'Clinical Summary'),
                const SizedBox(height: AppSpacing.sm),
                DoubleBezelCard(
                  child: Column(
                    children: [
                      _ProfileRow(label: 'National CPR ID', value: displayedUser.nationalId, tabular: true),
                      const RowRule(),
                      _ProfileRow(label: 'Blood Group', value: displayedProfile.bloodType),
                      const RowRule(),
                      _ProfileRow(
                        label: 'Chronic Conditions',
                        value: displayedProfile.chronicConditions.isEmpty
                            ? 'None on record'
                            : displayedProfile.chronicConditions.join(', '),
                      ),
                      const RowRule(),
                      _ProfileRow(
                        label: 'Known Allergies',
                        value: displayedProfile.allergies.isEmpty
                            ? 'No known allergies'
                            : displayedProfile.allergies.join(', '),
                      ),
                      const RowRule(),
                      _ProfileRow(label: 'Emergency Contact', value: displayedProfile.emergencyContact),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Family Section
              FamilySection(guardian: guardian),
              const SizedBox(height: AppSpacing.xxl),

              // Appearance Section
              const SectionHead(title: 'Appearance'),
              const SizedBox(height: AppSpacing.sm),
              DoubleBezelCard(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final label = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Theme',
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Choose light, dark, or match your device.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    );

                    if (constraints.maxWidth < 360) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label,
                          const SizedBox(height: AppSpacing.md),
                          const ThemeModeSelector(),
                        ],
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: label),
                        const SizedBox(width: AppSpacing.md),
                        const ThemeModeSelector(),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Account Section
              const SectionHead(title: 'Account'),
              const SizedBox(height: AppSpacing.sm),
              DoubleBezelCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.manage_accounts_outlined,
                        color: isDark ? AppColors.accent300 : AppColors.accent700,
                      ),
                      title: const Text('Switch Account'),
                      subtitle: const Text('Move between your accounts on this device'),
                      onTap: () => SwitchAccountSheet.show(context, currentUserId: guardian.id),
                    ),
                    const RowRule(),
                    ListTile(
                      leading: Icon(
                        Icons.swap_horiz_rounded,
                        color: isDark ? AppColors.accent300 : AppColors.accent700,
                      ),
                      title: const Text('Quick Switch Demo User'),
                      subtitle: const Text('Evaluate Doctor or Admin views'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const QuickSwitchUserDialog(),
                        );
                      },
                    ),
                    const RowRule(),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: AppColors.magentaInk),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: AppColors.magentaInk, fontWeight: FontWeight.w600),
                      ),
                      onTap: () => ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
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
  const _ProfileRow({required this.label, required this.value, this.tabular = false});

  final String label;
  final String value;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
