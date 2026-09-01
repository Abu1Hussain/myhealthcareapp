library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/features/admin/ai_settings_screen.dart';
import 'package:myhealth_ai/features/admin/audit_log_screen.dart';
import 'package:myhealth_ai/features/admin/department_schedule_screen.dart';
import 'package:myhealth_ai/features/admin/user_management_screen.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';

/// Admin navigation index state. Indices unchanged from the previous shell.
final adminNavIndexProvider = StateProvider<int>((ref) => 0);

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key});

  static const List<Widget> _screens = [
    UserManagementScreen(),
    DepartmentScheduleScreen(),
    AiSettingsScreen(),
    AuditLogScreen(),
  ];

  static const List<({IconData icon, IconData active, String label})> _dest = [
    (icon: Icons.people_outline_rounded, active: Icons.people_rounded, label: 'Users'),
    (icon: Icons.apartment_outlined, active: Icons.apartment_rounded, label: 'Depts'),
    (icon: Icons.memory_outlined, active: Icons.memory_rounded, label: 'AI'),
    (icon: Icons.receipt_long_outlined, active: Icons.receipt_long_rounded, label: 'Audit'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminNavIndexProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;
    final hairline =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (i) =>
                  ref.read(adminNavIndexProvider.notifier).state = i,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(Icons.settings_outlined, size: 24),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Switch user',
                          icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => const QuickSwitchUserDialog(),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Sign out',
                          icon: const Icon(Icons.logout_rounded, size: 20),
                          onPressed: () =>
                              ref.read(authControllerProvider.notifier).logout(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              destinations: _dest
                  .map((d) => NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.active),
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            Container(width: 1, color: hairline),
            Expanded(child: _screens[currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: hairline))),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => ref.read(adminNavIndexProvider.notifier).state = i,
          type: BottomNavigationBarType.fixed,
          items: _dest
              .map((d) => BottomNavigationBarItem(
                    icon: Icon(d.icon),
                    activeIcon: Icon(d.active),
                    label: d.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
