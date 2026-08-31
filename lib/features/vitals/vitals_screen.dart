library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/vitals/log_vitals_modal.dart';
import 'package:myhealth_ai/features/vitals/vitals_controller.dart';

class VitalsScreen extends ConsumerWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vitalsControllerProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitals & Health Trends'),
        actions: [
          IconButton(
            tooltip: 'Log New Vitals Entry',
            icon: const Icon(Icons.add_chart_rounded),
            onPressed: () {
              if (user != null) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => LogVitalsModal(patientId: user.id),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.isLoading) ...[
                const SkeletalShimmer(width: double.infinity, height: 260),
                const SizedBox(height: AppSpacing.lg),
                const SkeletalShimmer(width: double.infinity, height: 260),
              ] else if (state.vitals.isEmpty) ...[
                EmptyStateWidget(
                  icon: Icons.favorite_border_rounded,
                  title: 'No Vitals Logged',
                  description: 'Record your blood pressure, pulse, or glucose levels to visualize long-term trends.',
                  actionLabel: 'Log Vitals',
                  onAction: () {
                    if (user != null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => LogVitalsModal(patientId: user.id),
                      );
                    }
                  },
                ),
              ] else ...[
                // 1. Blood Pressure Dual-Line Chart (Systolic / Diastolic)
                DoubleBezelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite_rounded, color: AppColors.critical, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Blood Pressure Trend (mmHg)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Row(
                        children: [
                          Icon(Icons.horizontal_rule_rounded, color: AppColors.primaryTeal, size: 16),
                          Text(' Systolic  ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          Icon(Icons.horizontal_rule_rounded, color: AppColors.info, size: 16),
                          Text(' Diastolic', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true, drawVerticalLine: false),
                            titlesData: const FlTitlesData(
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              // Systolic Line
                              LineChartBarData(
                                spots: state.vitals
                                    .asMap()
                                    .entries
                                    .where((e) => e.value.systolic != null)
                                    .map((e) => FlSpot(e.key.toDouble(), e.value.systolic!))
                                    .toList(),
                                isCurved: true,
                                color: AppColors.primaryTeal,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                              ),
                              // Diastolic Line
                              LineChartBarData(
                                spots: state.vitals
                                    .asMap()
                                    .entries
                                    .where((e) => e.value.diastolic != null)
                                    .map((e) => FlSpot(e.key.toDouble(), e.value.diastolic!))
                                    .toList(),
                                isCurved: true,
                                color: AppColors.info,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // 2. Fasting Blood Glucose Trend Chart
                DoubleBezelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop_rounded, color: AppColors.warning, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Fasting Blood Glucose (mg/dL)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        height: 180,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true, drawVerticalLine: false),
                            titlesData: const FlTitlesData(
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: state.vitals
                                    .asMap()
                                    .entries
                                    .where((e) => e.value.glucose != null)
                                    .map((e) => FlSpot(e.key.toDouble(), e.value.glucose!))
                                    .toList(),
                                isCurved: true,
                                color: AppColors.warning,
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.warning.withValues(alpha: 0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
