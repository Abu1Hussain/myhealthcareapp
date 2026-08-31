library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/family/add_dependent_screen.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/family_link_store.dart';
import 'package:myhealth_ai/features/patient_home/patient_shell.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';

/// "Family" panel on the patient profile screen: lets a guardian see and
/// manage every dependent they've linked, add a new one, or jump into
/// managing one's account (their own timeline, vitals, appointments and
/// settings become the active record everywhere in the app).
class FamilySection extends ConsumerStatefulWidget {
  const FamilySection({super.key, required this.guardian});

  final User guardian;

  @override
  ConsumerState<FamilySection> createState() => _FamilySectionState();
}

class _FamilySectionState extends ConsumerState<FamilySection> {
  List<(FamilyLink, User)>? _dependents;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final links = await FamilyLinkStore.getDependentsFor(widget.guardian.id);
    final resolved = <(FamilyLink, User)>[];
    for (final link in links) {
      final result = await ref.read(userRepositoryProvider).getUserById(link.dependentUserId);
      result.fold((user) => resolved.add((link, user)), (_) {});
    }
    if (mounted) setState(() => _dependents = resolved);
  }

  Future<void> _addDependent() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddDependentScreen()),
    );
    if (added == true) await _load();
  }

  Future<void> _removeDependent(User dependent) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Family Member?'),
        content: Text(
          "${dependent.fullName} will no longer appear in your Family list. Their health record is not deleted.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: AppColors.critical)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await FamilyLinkStore.removeLink(guardianUserId: widget.guardian.id, dependentUserId: dependent.id);
      if (ref.read(managedDependentProvider)?.id == dependent.id) {
        ref.read(managedDependentProvider.notifier).state = null;
      }
      await _load();
    }
  }

  void _manage(User dependent) {
    ref.read(managedDependentProvider.notifier).state = dependent;
    // Jump to the Home tab so the switch is immediately visible rather
    // than leaving the guardian looking at their own Profile screen.
    ref.read(patientNavIndexProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final dependents = _dependents;
    final managingId = ref.watch(managedDependentProvider)?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Family',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton.icon(
              onPressed: _addDependent,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Manage a child or dependent\'s full health record — appointments, vitals, medications, and settings — from your account.',
          style: TextStyle(color: context.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (dependents == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (dependents.isEmpty)
          DoubleBezelCard(
            child: Text(
              'No family members added yet.',
              style: TextStyle(color: context.textSecondary, fontSize: 13),
            ),
          )
        else
          ...dependents.asMap().entries.map((entry) {
            final (link, dependent) = entry.value;
            final isManaging = managingId == dependent.id;

            return StaggeredFadeSlide(
              index: entry.key,
              child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: DoubleBezelCard(
                borderColor: isManaging ? AppColors.primaryTeal : null,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                      child: Text(
                        dependent.fullName.isNotEmpty ? dependent.fullName[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dependent.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(
                            '${link.relationship.label} • Age ${dependent.age}',
                            style: TextStyle(color: context.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (isManaging)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal, size: 20),
                      )
                    else
                      TextButton(
                        onPressed: () => _manage(dependent),
                        child: const Text('Manage', style: TextStyle(fontSize: 12.5)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Remove',
                      onPressed: () => _removeDependent(dependent),
                    ),
                  ],
                ),
              ),
              ),
            );
          }),
      ],
    );
  }
}
