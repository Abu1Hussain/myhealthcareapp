library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/features/staff/analytics/clinic_analytics_screen.dart';
import 'package:myhealth_ai/features/staff/dashboard/staff_dashboard_screen.dart';
import 'package:myhealth_ai/features/staff/patients/patient_search_screen.dart';
import 'package:myhealth_ai/features/staff/tasks/task_board_screen.dart';

/// Staff navigation index state.
final staffNavIndexProvider = StateProvider<int>((ref) => 0);

class StaffShell extends ConsumerWidget {
  const StaffShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(staffNavIndexProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;
    final hairline = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16);

    const screens = [
      StaffDashboardScreen(),
      TaskBoardScreen(),
      PatientSearchScreen(),
      ClinicAnalyticsScreen(),
    ];

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
                        onDestinationSelected: (index) =>
                            ref.read(staffNavIndexProvider.notifier).state = index,
                        labelType: NavigationRailLabelType.all,
                        leading: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Icon(Icons.local_hospital_outlined, size: 24),
                        ),
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.calendar_today_outlined),
                            selectedIcon: Icon(Icons.calendar_today_rounded),
                            label: Text('Schedule'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.assignment_outlined),
                            selectedIcon: Icon(Icons.assignment_rounded),
                            label: Text('Tasks'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.people_outline_rounded),
                            selectedIcon: Icon(Icons.people_rounded),
                            label: Text('Patients'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.insights_outlined),
                            selectedIcon: Icon(Icons.insights_rounded),
                            label: Text('Analytics'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(width: 1, color: hairline),
            Expanded(child: screens[currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: hairline)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(staffNavIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights_rounded),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}
