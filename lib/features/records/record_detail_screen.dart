library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key, required this.record});

  final MedicalRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(record.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Masthead info
              Eyebrow(formatClinicalDate(record.occurredAt), accent: true),
              const SizedBox(height: 6),
              Text(
                record.title,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 28,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  ClinicalBadge.recordType(record.recordType),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Source: ${record.sourceFacility}${record.authorName != null ? ' · Dr. ${record.authorName}' : ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Clinical Body / Notes
              const SectionHead(title: 'Clinical Summary'),
              const SizedBox(height: AppSpacing.md),
              Text(
                record.body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.65,
                ),
              ),

              // Structured Lab Results (if any)
              if (record.labValues.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                SectionHead(
                  title: 'Laboratory Values',
                  trailing: Text(
                    '${record.labValues.length} analytes',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final lab in record.labValues)
                  _LabRow(lab: lab),
              ],

              // Attachment / Extracted Text Section
              if (record.extractedText != null && record.extractedText!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Parsed Document Text'),
                const SizedBox(height: AppSpacing.md),
                DoubleBezelCard(
                  filled: true,
                  child: Text(
                    record.extractedText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.6,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
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

class _LabRow extends StatelessWidget {
  const _LabRow({required this.lab});

  final LabValue lab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lab.analyte,
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ref: ${lab.refLow.toStringAsFixed(1)}–${lab.refHigh.toStringAsFixed(1)} ${lab.unit}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${lab.value.toStringAsFixed(lab.value.truncateToDouble() == lab.value ? 0 : 1)} ${lab.unit}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: lab.abnormalFlag
                            ? AppColors.magentaInk
                            : theme.colorScheme.onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (lab.abnormalFlag) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const ClinicalBadge(
                        label: 'Abnormal',
                        tone: ClinicalTone.critical,
                      ),
                    ],
                  ],
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
