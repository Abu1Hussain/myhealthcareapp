library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Schedule & Availability'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Masthead Profile Card
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 20,
                          color: isDark ? AppColors.accent300 : AppColors.accent700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${staff.fullName} · Clinic Schedule',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Department: ${staff.staffProfile?.specialty ?? "General Practice"} · Room ${staff.staffProfile?.jobTitle ?? "A-101"}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const RowRule(),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Consultation Slot Duration',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
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
              const SizedBox(height: AppSpacing.xxl),

              const SectionHead(
                title: 'Weekly Working Days',
                trailing: Eyebrow('Bahrain standard week'),
              ),
              const SizedBox(height: AppSpacing.sm),

              DoubleBezelCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: _workingDays.keys.map((day) {
                    final isWorking = _workingDays[day]!;
                    final isWeekend = day == DateTime.friday || day == DateTime.saturday;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _weekdayName(day),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isWeekend
                                            ? theme.colorScheme.onSurfaceVariant
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isWorking
                                          ? '08:00 – 16:00 (${(8 * 60 / _slotDurationMinutes).round()} slots/day)'
                                          : 'Day Off / Closed',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontFeatures: const [FontFeature.tabularFigures()],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isWorking,
                                activeThumbColor: isDark ? AppColors.accent400 : AppColors.cyanInk,
                                onChanged: (val) {
                                  setState(() => _workingDays[day] = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (day != _workingDays.keys.last) const RowRule(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
