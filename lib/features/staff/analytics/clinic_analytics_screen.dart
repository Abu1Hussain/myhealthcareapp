library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

class ClinicAnalyticsScreen extends ConsumerWidget {
  const ClinicAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Analytics & ML Insights'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top KPI Summary Cards
              Row(
                children: const [
                  Expanded(child: _KpiCard(label: 'Attendance Rate', value: '78.4%', change: '+4.2% vs baseline', isGood: true)),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: _KpiCard(label: 'Avg No-Show Rate', value: '21.6%', change: '-4.2% with reminders', isGood: true)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: const [
                  Expanded(child: _KpiCard(label: 'ML ROC-AUC', value: '0.785', change: 'Logistic Reg.', isGood: true)),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: _KpiCard(label: 'High-Risk Triage', value: '14.2%', change: '3-tier escalation', isGood: true)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Attendance Distribution Pie Chart
              Text(
                'Overall Appointment Attendance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              DoubleBezelCard(
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              value: 78.4,
                              title: '78.4%',
                              color: AppColors.primaryTeal,
                              radius: 50,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            ),
                            PieChartSectionData(
                              value: 21.6,
                              title: '21.6%',
                              color: AppColors.critical,
                              radius: 50,
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _Legend(color: AppColors.primaryTeal, label: 'Attended / Completed'),
                        SizedBox(width: AppSpacing.lg),
                        _Legend(color: AppColors.critical, label: 'No-Show'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Department No-Show Rate Bar Chart
              Text(
                'No-Show Rate by Department (%)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              DoubleBezelCard(
                child: SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 35,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              const labels = ['Internal', 'Cardio', 'Endo', 'Pulm', 'Nephro'];
                              if (val.toInt() >= 0 && val.toInt() < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(labels[val.toInt()], style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 24, color: AppColors.warning, width: 18, borderRadius: BorderRadius.circular(4))]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 18, color: AppColors.primaryTeal, width: 18, borderRadius: BorderRadius.circular(4))]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 28, color: AppColors.critical, width: 18, borderRadius: BorderRadius.circular(4))]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppColors.primaryTeal, width: 18, borderRadius: BorderRadius.circular(4))]),
                        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 12, color: AppColors.success, width: 18, borderRadius: BorderRadius.circular(4))]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.change,
    required this.isGood,
  });

  final String label;
  final String value;
  final String change;
  final bool isGood;

  @override
  Widget build(BuildContext context) {
    return DoubleBezelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: context.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            change,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isGood ? AppColors.success : AppColors.critical,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
      ],
    );
  }
}
