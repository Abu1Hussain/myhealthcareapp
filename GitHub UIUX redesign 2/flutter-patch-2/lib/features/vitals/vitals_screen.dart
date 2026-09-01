library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/vitals/log_vitals_modal.dart';
import 'package:myhealth_ai/features/vitals/vitals_controller.dart';

/// Which series the trend is drawn for.
enum _Metric { pressure, glucose, weight }

extension _MetricInfo on _Metric {
  String get label {
    switch (this) {
      case _Metric.pressure:
        return 'Pressure';
      case _Metric.glucose:
        return 'Glucose';
      case _Metric.weight:
        return 'Weight';
    }
  }

  String get unit {
    switch (this) {
      case _Metric.pressure:
        return 'mmHg';
      case _Metric.glucose:
        return 'mg/dL';
      case _Metric.weight:
        return 'kg';
    }
  }

  /// Reference band printed behind the line. Standard adult ranges — the
  /// same ones the seeder's lab analytes use.
  ({double low, double high})? get reference {
    switch (this) {
      case _Metric.pressure:
        return (low: 90, high: 120);
      case _Metric.glucose:
        return (low: 70, high: 99);
      case _Metric.weight:
        return null;
    }
  }

  double? read(VitalsRecord r) {
    switch (this) {
      case _Metric.pressure:
        return r.systolic;
      case _Metric.glucose:
        return r.glucose;
      case _Metric.weight:
        return r.weightKg;
    }
  }
}

/// Vitals — one metric at a time, at reading size.
///
/// The reference band prints *behind* the trend line rather than as a
/// coloured badge beside a number, so "is this in range" is answered by
/// where the line sits, not by decoding a colour.
class VitalsScreen extends ConsumerStatefulWidget {
  const VitalsScreen({super.key});

  @override
  ConsumerState<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends ConsumerState<VitalsScreen> {
  _Metric _metric = _Metric.pressure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(vitalsControllerProvider);
    final user = ref.watch(currentUserProvider);
    final patientId = user == null ? null : effectivePatientId(ref, user);

    // Oldest first for the trend line.
    final series = [...state.vitals]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final points = series
        .where((r) => _metric.read(r) != null)
        .map((r) => (at: r.recordedAt, value: _metric.read(r)!))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      'Vitals',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 32,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _Segmented(
                options: _Metric.values.map((m) => m.label).toList(),
                selectedIndex: _Metric.values.indexOf(_metric),
                onSelected: (i) => setState(() => _metric = _Metric.values[i]),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (state.isLoading) ...[
                const SkeletalShimmer(width: 180, height: 48),
                const SizedBox(height: AppSpacing.lg),
                const SkeletalShimmer(width: double.infinity, height: 150),
              ] else if (points.isEmpty) ...[
                EmptyStateWidget(
                  icon: Icons.show_chart_rounded,
                  title: 'No ${_metric.label.toLowerCase()} readings yet',
                  description: 'Log a reading and the trend will draw itself '
                      'here, with the reference range behind it.',
                  actionLabel: patientId == null ? null : 'Log a reading',
                  onAction: patientId == null
                      ? null
                      : () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => LogVitalsModal(patientId: patientId),
                          ),
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Eyebrow('Latest reading'),
                          const SizedBox(height: 4),
                          FigureBlock(
                            value: points.last.value.toStringAsFixed(
                              points.last.value.truncateToDouble() == points.last.value ? 0 : 1,
                            ),
                            unit: _metric.unit,
                            size: 48,
                          ),
                        ],
                      ),
                    ),
                    if (_metric.reference != null)
                      Text(
                        'reference\n${_metric.reference!.low.toStringAsFixed(0)} – '
                        '${_metric.reference!.high.toStringAsFixed(0)}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 160,
                  child: CustomPaint(
                    painter: _TrendPainter(
                      values: points.map((p) => p.value).toList(),
                      reference: _metric.reference,
                      lineColor: theme.brightness == Brightness.dark
                          ? AppColors.accent400
                          : AppColors.cyanInk,
                      bandColor: theme.colorScheme.onSurface.withValues(alpha: 0.07),
                      dotColor: theme.colorScheme.onSurface,
                      lastDotColor: AppColors.magentaInk,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatClinicalDate(points.first.at),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      formatClinicalDate(points.last.at),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Logged readings'),
                for (final r in series.reversed.take(10)) _VitalsRow(record: r),

                const SizedBox(height: AppSpacing.xl),
                if (patientId != null)
                  ElevatedButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => LogVitalsModal(patientId: patientId),
                    ),
                    child: const Text('Log a reading'),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The system's segmented control, in Flutter.
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hairline = theme.colorScheme.onSurface.withValues(alpha: 0.16);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: hairline),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < options.length; i++)
            InkWell(
              onTap: () => onSelected(i),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? (isDark ? AppColors.accent400 : AppColors.cyanInk)
                      : Colors.transparent,
                  border: i == 0
                      ? null
                      : Border(left: BorderSide(color: hairline)),
                ),
                child: Center(
                  child: Text(
                    options[i],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w400,
                      color: i == selectedIndex
                          ? (isDark ? AppColors.canvasDark : AppColors.paper)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Trend line over its reference band. Nothing is filled, nothing glows:
/// one hairline band, one stroke, one mark per reading.
class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.values,
    required this.reference,
    required this.lineColor,
    required this.bandColor,
    required this.dotColor,
    required this.lastDotColor,
  });

  final List<double> values;
  final ({double low, double high})? reference;
  final Color lineColor;
  final Color bandColor;
  final Color dotColor;
  final Color lastDotColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    var min = values.reduce((a, b) => a < b ? a : b);
    var max = values.reduce((a, b) => a > b ? a : b);
    if (reference != null) {
      min = min < reference!.low ? min : reference!.low;
      max = max > reference!.high ? max : reference!.high;
    }
    final pad = (max - min) * 0.18 + 1;
    min -= pad;
    max += pad;

    double y(double v) => size.height - ((v - min) / (max - min)) * size.height;
    double x(int i) => values.length == 1
        ? size.width / 2
        : (i / (values.length - 1)) * size.width;

    if (reference != null) {
      final top = y(reference!.high);
      final bottom = y(reference!.low);
      canvas.drawRect(
        Rect.fromLTRB(0, top, size.width, bottom),
        Paint()..color = bandColor,
      );
    }

    final path = Path()..moveTo(x(0), y(values.first));
    for (var i = 1; i < values.length; i++) {
      path.lineTo(x(i), y(values[i]));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    for (var i = 0; i < values.length; i++) {
      final isLast = i == values.length - 1;
      canvas.drawCircle(
        Offset(x(i), y(values[i])),
        isLast ? 4.5 : 2.5,
        Paint()..color = isLast ? lastDotColor : dotColor,
      );
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.values != values || old.reference != reference;
}

class _VitalsRow extends StatelessWidget {
  const _VitalsRow({required this.record});

  final VitalsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <String>[
      if (record.systolic != null && record.diastolic != null)
        '${record.systolic!.toStringAsFixed(0)} / ${record.diastolic!.toStringAsFixed(0)} mmHg',
      if (record.heartRate != null) '${record.heartRate!.toStringAsFixed(0)} bpm',
      if (record.glucose != null) '${record.glucose!.toStringAsFixed(0)} mg/dL',
      if (record.weightKg != null) '${record.weightKg!.toStringAsFixed(1)} kg',
      if (record.spo2 != null) 'SpO₂ ${record.spo2!.toStringAsFixed(0)}%',
      if (record.tempC != null) '${record.tempC!.toStringAsFixed(1)} °C',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 92,
                child: Text(
                  formatClinicalDate(record.recordedAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  parts.isEmpty ? 'No values recorded' : parts.join('  ·  '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Text(
                formatTime24h(record.recordedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        const RowRule(),
      ],
    );
  }
}
