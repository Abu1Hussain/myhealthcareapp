library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key, required this.record});

  final MedicalRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClinicalBadge(
                          label: record.recordType.name.toUpperCase(),
                          backgroundColor: AppColors.primaryTealSurface,
                          textColor: AppColors.primaryTeal,
                        ),
                        const Spacer(),
                        Text(
                          formatClinicalDate(record.occurredAt),
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      record.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Source: ${record.sourceFacility}${record.authorName != null ? ' • Dr. ${record.authorName}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Clinical Body / Notes
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clinical Summary / Body',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      record.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),

              // Structured Lab Results (if any)
              if (record.labValues.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Laboratory Values',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DoubleBezelCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: record.labValues.map((lab) {
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: context.borderColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lab.analyte,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                  Text(
                                    'Reference: ${lab.refLow} – ${lab.refHigh} ${lab.unit}',
                                    style: TextStyle(color: context.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${lab.value} ${lab.unit}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: lab.abnormalFlag ? AppColors.critical : context.textPrimary,
                              ),
                            ),
                            if (lab.abnormalFlag) ...[
                              const SizedBox(width: AppSpacing.sm),
                              const ClinicalBadge(
                                label: 'ABNORMAL',
                                backgroundColor: Color(0x20EF4444),
                                textColor: AppColors.critical,
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              // Attachment / Extracted Text Section
              if (record.extractedText != null && record.extractedText!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                DoubleBezelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_rounded, color: AppColors.critical, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Parsed Document Text',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.canvasColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          record.extractedText!,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5,
                            color: context.textPrimary,
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
