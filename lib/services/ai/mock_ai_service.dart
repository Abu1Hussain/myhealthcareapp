library;

import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/ai/ai_service.dart';
import 'package:myhealth_ai/services/ai/patient_context_builder.dart';
import 'package:myhealth_ai/services/ai/prompts/summarize_records.dart';

/// Deterministic offline AI summarization service for defense insurance (RQ1).
/// Guarantees instant, zero-cost, plausible summaries without network dependencies.
class MockAiService implements AiService {
  @override
  String get modelId => 'mock-ai-v1';

  @override
  String get promptVersion => SummarizeRecordsPrompt.version;

  @override
  Future<Result<AiHealthSummary, AppFailure>> generateSummary({
    required User patient,
    required List<MedicalRecord> records,
    required List<VitalsRecord> vitals,
    required List<Medication> medications,
    String? customPrompt,
  }) async {
    // Simulate brief processing delay
    await Future.delayed(const Duration(milliseconds: 250));

    final contextBundle = PatientContextBuilder.buildContext(
      patient: patient,
      records: records,
      vitals: vitals,
      medications: medications,
    );

    final conditions = patient.patientProfile?.chronicConditions ?? [];
    final hasDiabetes = conditions.any((c) => c.toLowerCase().contains('diabetes'));
    final hasHypertension = conditions.any((c) => c.toLowerCase().contains('hypertension'));
    final hasAsthma = conditions.any((c) => c.toLowerCase().contains('asthma'));

    // 1. Build Markdown narrative
    final markdownBuffer = StringBuffer();
    markdownBuffer.writeln('### Clinical Overview for ${patient.fullName}\n');

    if (hasDiabetes || hasHypertension || hasAsthma) {
      final activeList = conditions.join(' and ');
      markdownBuffer.writeln(
        'Patient is an active **${patient.age}-year-old** with established diagnosis of **$activeList**.',
      );
    } else {
      markdownBuffer.writeln(
        'Patient is an active **${patient.age}-year-old** presenting for periodic health evaluation with no major chronic conditions.',
      );
    }

    markdownBuffer.writeln(
      '\n#### Key Findings & Treatment Adherence\n'
      '- **Medication Adherence:** Patient is currently prescribed ${medications.length} active medication(s). Review indicates consistent renewal.\n'
      '- **Vitals Evaluation:** Longitudinal vitals observations demonstrate moderate stability with expected seasonal variance.\n'
      '- **Laboratory Summary:** Recent blood work and metabolic panels have been synchronized into the unified timeline.',
    );

    markdownBuffer.writeln(
      '\n#### Recommended Clinician Next Steps\n'
      '1. Schedule routine 3-month follow-up consultation.\n'
      '2. Continue current pharmacotherapy regimen without dose adjustments.\n'
      '3. Re-evaluate quarterly lab markers during next scheduled visit.',
    );

    // 2. Key Events
    final keyEvents = <AiKeyEvent>[];
    if (records.isNotEmpty) {
      final recent = records.first;
      keyEvents.add(
        AiKeyEvent(
          date: formatClinicalDate(recent.occurredAt),
          title: recent.title,
          category: recent.recordType.name.toUpperCase(),
          importance: 'High',
        ),
      );
    }

    if (hasDiabetes) {
      keyEvents.add(
        AiKeyEvent(
          date: formatClinicalDate(DateTime.now().subtract(const Duration(days: 45))),
          title: 'Metabolic & Glycemic Review (HbA1c)',
          category: 'Lab',
          importance: 'High',
        ),
      );
    }

    if (hasHypertension) {
      keyEvents.add(
        AiKeyEvent(
          date: formatClinicalDate(DateTime.now().subtract(const Duration(days: 90))),
          title: 'Cardiovascular Evaluation & Blood Pressure Check',
          category: 'Diagnosis',
          importance: 'Medium',
        ),
      );
    }

    // 3. Trends
    final trends = <AiTrend>[];
    if (hasHypertension || vitals.any((v) => (v.systolic ?? 0) > 130)) {
      trends.add(
        const AiTrend(
          metric: 'Systolic Blood Pressure',
          direction: 'stable',
          significance: 'Maintained within target therapeutic window on current ACE inhibitor therapy.',
          chartKey: 'bp',
        ),
      );
    }

    if (hasDiabetes || vitals.any((v) => (v.glucose ?? 0) > 120)) {
      trends.add(
        const AiTrend(
          metric: 'Fasting Blood Glucose',
          direction: 'improving',
          significance: 'Fasting glucose levels trending toward target range (<110 mg/dL).',
          chartKey: 'glucose',
        ),
      );
    } else {
      trends.add(
        const AiTrend(
          metric: 'Resting Heart Rate',
          direction: 'stable',
          significance: 'Resting pulse consistent around 72 bpm across all observations.',
          chartKey: 'hr',
        ),
      );
    }

    // 4. Red Flags
    final redFlags = <String>[];
    if (vitals.any((v) => (v.systolic ?? 0) >= 140)) {
      redFlags.add('Intermittent systolic blood pressure readings >= 140 mmHg recorded.');
    }
    if (records.any((r) => r.labValues.any((l) => l.abnormalFlag))) {
      redFlags.add('One or more laboratory analytes flagged above standard reference ranges.');
    }

    return Success(
      AiHealthSummary(
        id: 0,
        patientId: patient.id,
        generatedAt: DateTime.now(),
        modelId: modelId,
        promptVersion: promptVersion,
        summaryMarkdown: markdownBuffer.toString(),
        keyEvents: keyEvents,
        trends: trends,
        redFlags: redFlags,
        inputHash: contextBundle.inputHash,
      ),
    );
  }
}
