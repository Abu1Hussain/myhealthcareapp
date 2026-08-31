library;

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
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guardian = ref.watch(currentUserProvider);
    if (guardian == null) return const SizedBox.shrink();

    // A guardian managing a dependent sees and edits THAT record here;
    // account-level actions below (switch account, family list, sign
    // out) always stay tied to the real logged-in guardian.
    final managedDependent = ref.watch(managedDependentProvider);
    final displayedUser = managedDependent ?? guardian;
    final displayedProfile = displayedUser.patientProfile;
    final isManaging = managedDependent != null;

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

              // Active Profile Avatar Card (self, or the managed dependent)
              DoubleBezelCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                      child: Text(
                        displayedUser.fullName[0],
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayedUser.fullName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isManaging ? 'Age ${displayedUser.age}' : displayedUser.email,
                            style: TextStyle(color: context.textSecondary, fontSize: 13),
                          ),
                          if (!isManaging) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Phone: ${displayedUser.phone}',
                              style: TextStyle(color: context.textSecondary, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Clinical Data Details Card
              if (displayedProfile != null) ...[
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
                      _ProfileRow(label: 'National CPR ID', value: displayedUser.nationalId),
                      const Divider(),
                      _ProfileRow(label: 'Blood Group', value: displayedProfile.bloodType),
                      const Divider(),
                      _ProfileRow(
                        label: 'Chronic Conditions',
                        value: displayedProfile.chronicConditions.isEmpty
                            ? 'None on record'
                            : displayedProfile.chronicConditions.join(', '),
                      ),
                      const Divider(),
                      _ProfileRow(
                        label: 'Known Allergies',
                        value: displayedProfile.allergies.isEmpty
                            ? 'No known allergies'
                            : displayedProfile.allergies.join(', '),
                      ),
                      const Divider(),
                      _ProfileRow(label: 'Emergency Contact', value: displayedProfile.emergencyContact),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Family (always the real guardian's own links, never the
              // dependent's — a child does not manage their own family list)
              FamilySection(guardian: guardian),
              const SizedBox(height: AppSpacing.xl),

              // Appearance
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Choose light, dark, or match your device.',
                          style: TextStyle(color: context.textSecondary, fontSize: 12),
                        ),
                      ],
                    );

                    // Narrow phones stack the picker below the label instead
                    // of squeezing a 3-segment control into a shared row.
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
              const SizedBox(height: AppSpacing.xl),

              // System Preferences & Actions — always the real guardian's
              // account, regardless of who is currently being managed.
              Text(
                'Account',
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
                        leading: const Icon(Icons.manage_accounts_rounded, color: AppColors.primaryTeal),
                        title: const Text('Switch Account'),
                        subtitle: const Text('Move between your accounts on this device'),
                        onTap: () => SwitchAccountSheet.show(context, currentUserId: guardian.id),
                      ),
                      const Divider(height: 1),
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
          Text(label, style: TextStyle(color: context.textSecondary, fontSize: 13)),
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
