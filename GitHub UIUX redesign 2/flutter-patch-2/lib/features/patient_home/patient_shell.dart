library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/features/patient_home/patient_home_screen.dart';
import 'package:myhealth_ai/features/profile/patient_profile_screen.dart';
import 'package:myhealth_ai/features/scheduling/booking_wizard_screen.dart';
import 'package:myhealth_ai/features/timeline/timeline_screen.dart';

/// Patient navigation index state.
final patientNavIndexProvider = StateProvider<int>((ref) => 0);

/// Tab indices, named.
///
/// Six tabs became four. Timeline and Records merged into Chart; Meds and
/// Profile merged into You; Vitals and Appointments became pushed routes
/// reachable from the screens that reference them. Six destinations across
/// the bottom of a phone left no label room and split one mental model —
/// "my record" — across three tabs.
abstract final class PatientTab {
  static const int today = 0;
  static const int chart = 1;
  static const int book = 2;
  static const int you = 3;
}

class PatientShell extends ConsumerWidget {
  const PatientShell({super.key});

  static const List<Widget> _screens = [
    PatientHomeScreen(),
    TimelineScreen(),
    BookingWizardScreen(),
    PatientProfileScreen(),
  ];

  static const List<({IconData icon, IconData active, String label})> _dest = [
    (icon: Icons.wb_twilight_outlined, active: Icons.wb_twilight_rounded, label: 'Today'),
    (icon: Icons.folder_outlined, active: Icons.folder_rounded, label: 'Chart'),
    (icon: Icons.event_outlined, active: Icons.event_rounded, label: 'Book'),
    (icon: Icons.person_outline_rounded, active: Icons.person_rounded, label: 'You'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(patientNavIndexProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;
    final theme = Theme.of(context);
    final hairline = theme.colorScheme.onSurface.withValues(alpha: 0.16);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  primary: false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: currentIndex,
                        onDestinationSelected: (i) =>
                            ref.read(patientNavIndexProvider.notifier).state = i,
                        labelType: NavigationRailLabelType.all,
                        leading: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Icon(Icons.favorite_rounded, size: 24),
                        ),
                        destinations: _dest
                            .map((d) => NavigationRailDestination(
                                  icon: Icon(d.icon),
                                  selectedIcon: Icon(d.active),
                                  label: Text(d.label),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
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
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: hairline)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => ref.read(patientNavIndexProvider.notifier).state = i,
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
