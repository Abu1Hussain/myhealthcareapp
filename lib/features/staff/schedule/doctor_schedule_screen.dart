library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

class DoctorScheduleScreen extends ConsumerStatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  ConsumerState<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends ConsumerState<DoctorScheduleScreen> {
  final Map<int, bool> _workingDays = {
    DateTime.sunday: true,
    DateTime.monday: true,
    DateTime.tuesday: true,
    DateTime.wednesday: true,
    DateTime.thursday: true,
    DateTime.friday: false,
    DateTime.saturday: false,
  };

  int _slotDurationMinutes = 30;

  String _weekdayName(int day) {
    switch (day) {
      case DateTime.sunday:
        return 'Sunday';
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday (Weekend)';
      case DateTime.saturday:
        return 'Saturday (Weekend)';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(currentUserProvider);
    if (staff == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Schedule & Availability'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, color: AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        Text(
                          '${staff.fullName} • Clinic Schedule',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Department: ${staff.staffProfile?.specialty ?? "General Practice"} • Room ${staff.staffProfile?.jobTitle ?? "A-101"}',
                      style: TextStyle(color: context.textSecondary, fontSize: 12),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consultation Slot Duration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        DropdownButton<int>(
                          value: _slotDurationMinutes,
                          items: const [
                            DropdownMenuItem(value: 15, child: Text('15 minutes')),
                            DropdownMenuItem(value: 30, child: Text('30 minutes')),
                            DropdownMenuItem(value: 45, child: Text('45 minutes')),
                            DropdownMenuItem(value: 60, child: Text('60 minutes')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _slotDurationMinutes = val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Weekly Working Days (Bahrain Working Week)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),

              ..._workingDays.keys.map((day) {
                final isWorking = _workingDays[day]!;
                final isWeekend = day == DateTime.friday || day == DateTime.saturday;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: DoubleBezelCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _weekdayName(day),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isWeekend ? context.textSecondary : context.textPrimary,
                                ),
                              ),
                              Text(
                                isWorking ? '08:00 – 16:00 (16 available slots/day)' : 'Day Off / Closed',
                                style: TextStyle(color: context.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isWorking,
                          onChanged: (val) {
                            setState(() => _workingDays[day] = val);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
