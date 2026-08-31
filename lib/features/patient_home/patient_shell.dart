library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/features/medications/medications_screen.dart';
import 'package:myhealth_ai/features/patient_home/patient_home_screen.dart';
import 'package:myhealth_ai/features/profile/patient_profile_screen.dart';
import 'package:myhealth_ai/features/scheduling/patient_appointments_screen.dart';
import 'package:myhealth_ai/features/timeline/timeline_screen.dart';
import 'package:myhealth_ai/features/vitals/vitals_screen.dart';

/// Patient navigation index state.
final patientNavIndexProvider = StateProvider<int>((ref) => 0);

class PatientShell extends ConsumerWidget {
  const PatientShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(patientNavIndexProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;

    const screens = [
      PatientHomeScreen(),
      PatientAppointmentsScreen(),
      TimelineScreen(),
      VitalsScreen(),
      MedicationsScreen(),
      PatientProfileScreen(),
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
                            ref.read(patientNavIndexProvider.notifier).state = index,
                        labelType: NavigationRailLabelType.all,
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                            child: const Icon(Icons.health_and_safety_rounded, color: AppColors.primaryTeal),
                          ),
                        ),
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home_rounded),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.event_note_outlined),
                            selectedIcon: Icon(Icons.event_note_rounded),
                            label: Text('Appts'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.timeline_outlined),
                            selectedIcon: Icon(Icons.timeline_rounded),
                            label: Text('Timeline'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite_outline_rounded),
                            selectedIcon: Icon(Icons.favorite_rounded),
                            label: Text('Vitals'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.medication_outlined),
                            selectedIcon: Icon(Icons.medication_rounded),
                            label: Text('Meds'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.person_outline_rounded),
                            selectedIcon: Icon(Icons.person_rounded),
                            label: Text('Profile'),
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
        onTap: (index) => ref.read(patientNavIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note_rounded),
            label: 'Appts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            activeIcon: Icon(Icons.timeline_rounded),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Vitals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication_rounded),
            label: 'Meds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
