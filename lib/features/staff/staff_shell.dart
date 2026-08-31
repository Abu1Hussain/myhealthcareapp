library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
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
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                            child: const Icon(Icons.local_hospital_rounded, color: AppColors.primaryTeal),
                          ),
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
            const VerticalDivider(thickness: 1, width: 1),
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
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
