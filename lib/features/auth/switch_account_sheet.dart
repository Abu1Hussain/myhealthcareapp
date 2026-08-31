library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myhealth_ai/app/router.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/auth/remembered_accounts_store.dart';

/// Real multi-account switcher: lists accounts that have previously
/// signed in on this device (no passwords stored) and lets the user jump
/// to one — re-entering only the password — or sign in as someone new.
///
/// Distinct from [QuickSwitchUserDialog], which is a fixed defense-demo
/// account list, not a genuine per-device account history.
class SwitchAccountSheet extends ConsumerStatefulWidget {
  const SwitchAccountSheet({super.key, required this.currentUserId});

  final int currentUserId;

  static Future<void> show(BuildContext context, {required int currentUserId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SwitchAccountSheet(currentUserId: currentUserId),
    );
  }

  @override
  ConsumerState<SwitchAccountSheet> createState() => _SwitchAccountSheetState();
}

class _SwitchAccountSheetState extends ConsumerState<SwitchAccountSheet> {
  List<RememberedAccount>? _accounts;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final accounts = await RememberedAccountsStore.getAll();
    if (mounted) setState(() => _accounts = accounts);
  }

  Future<void> _forget(int userId) async {
    await RememberedAccountsStore.forget(userId);
    await _load();
  }

  Future<void> _switchTo(RememberedAccount account) async {
    ref.read(loginPrefillEmailProvider.notifier).state = account.email;
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pop();
      context.go(AppRoutes.login);
    }
  }

  Future<void> _addAccount() async {
    ref.read(loginPrefillEmailProvider.notifier).state = '';
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pop();
      context.go(AppRoutes.login);
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'patient':
        return 'Patient';
      case 'staff':
        return 'Staff';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _accounts;
    final others = accounts?.where((a) => a.userId != widget.currentUserId).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          ),
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Switch account',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                "Accounts that have signed in on this device. You'll re-enter your password to switch.",
                style: TextStyle(color: context.textSecondary, fontSize: 12.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (accounts == null) ...[
                const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.lg), child: CircularProgressIndicator())),
              ] else if (others!.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    'No other accounts remembered on this device yet.',
                    style: TextStyle(color: context.textSecondary, fontSize: 13),
                  ),
                ),
              ] else
                ...others.map((account) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: context.surfaceElevated,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                            child: Text(
                              account.fullName.isNotEmpty ? account.fullName[0].toUpperCase() : '?',
                              style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(account.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: Text(
                            '${_roleLabel(account.role)} • ${account.email}',
                            style: const TextStyle(fontSize: 11.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            tooltip: 'Remove from this device',
                            onPressed: () => _forget(account.userId),
                          ),
                          onTap: () => _switchTo(account),
                        ),
                      ),
                    )),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: _addAccount,
                icon: const Icon(Icons.person_add_alt_rounded, size: 18),
                label: const Text('Sign in with a different account'),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
            ),
          ),
        ),
      ),
    );
  }
}
