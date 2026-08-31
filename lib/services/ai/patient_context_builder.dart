library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Bundled context result containing formatted prompt text and SHA-256 cache key.
class PatientContextBundle {
  const PatientContextBundle({
    required this.formattedContext,
    required this.inputHash,
  });

  final String formattedContext;
  final String inputHash;
}

/// Serializes heterogeneous patient history into a recency-weighted, token-budgeted prompt string.
abstract final class PatientContextBuilder {
  static const int maxCharacterBudget = 14000; // ~3,500 tokens

  static PatientContextBundle buildContext({
    required User patient,
    required List<MedicalRecord> records,
    required List<VitalsRecord> vitals,
    required List<Medication> medications,
  }) {
    final buffer = StringBuffer();

    // 1. Patient Demographics & Profile
    buffer.writeln('=== PATIENT DEMOGRAPHICS ===');
    buffer.writeln('Name: ${patient.fullName}');
    buffer.writeln('Age: ${patient.age} (${patient.dob.year}-${patient.dob.month}-${patient.dob.day})');
    buffer.writeln('Gender: ${patient.gender == 'M' ? 'Male' : 'Female'}');
    buffer.writeln('CPR / National ID: ${patient.nationalId}');

    if (patient.patientProfile != null) {
      final p = patient.patientProfile!;
      buffer.writeln('Blood Type: ${p.bloodType}');
      buffer.writeln('Chronic Conditions: ${p.chronicConditions.isEmpty ? 'None recorded' : p.chronicConditions.join(', ')}');
      buffer.writeln('Allergies: ${p.allergies.isEmpty ? 'No known allergies' : p.allergies.join(', ')}');
    }
    buffer.writeln();

    // 2. Active Medications
    buffer.writeln('=== ACTIVE MEDICATIONS ===');
    final activeMeds = medications.where((m) => m.isActive).toList();
    if (activeMeds.isEmpty) {
      buffer.writeln('No active prescriptions.');
    } else {
      for (final m in activeMeds) {
        buffer.writeln('- ${m.name} ${m.dose} (${m.frequency}), started ${formatClinicalDate(m.startDate)}');
      }
    }
    buffer.writeln();

    // 3. Recent Vitals (Last 10 observations)
    buffer.writeln('=== RECENT VITALS OBSERVATIONS ===');
    final recentVitals = vitals.take(10).toList();
    if (recentVitals.isEmpty) {
      buffer.writeln('No vitals records available.');
    } else {
      for (final v in recentVitals) {
        final parts = <String>[];
        if (v.systolic != null && v.diastolic != null) parts.add('BP: ${v.systolic!.round()}/${v.diastolic!.round()} mmHg');
        if (v.heartRate != null) parts.add('HR: ${v.heartRate!.round()} bpm');
        if (v.glucose != null) parts.add('Glucose: ${v.glucose!.round()} mg/dL');
        if (v.weightKg != null) parts.add('Weight: ${v.weightKg!.toStringAsFixed(1)} kg');
        if (v.tempC != null) parts.add('Temp: ${v.tempC!.toStringAsFixed(1)}°C');

        buffer.writeln('${formatClinicalDate(v.recordedAt)}: ${parts.join(' | ')}');
      }
    }
    buffer.writeln();

    // 4. Clinical Records (Recency-sorted, with lab values & parsed PDF text)
    buffer.writeln('=== CLINICAL RECORDS & TIMELINE ===');
    if (records.isEmpty) {
      buffer.writeln('No past clinical records.');
    } else {
      for (final r in records.take(15)) {
        buffer.writeln('--- [${r.recordType.name.toUpperCase()}] ${r.title} (${formatClinicalDate(r.occurredAt)}) ---');
        buffer.writeln('Facility: ${r.sourceFacility}${r.authorName != null ? ' | Dr. ${r.authorName}' : ''}');
        buffer.writeln('Summary: ${r.body}');

        if (r.labValues.isNotEmpty) {
          buffer.writeln('Lab Analytes:');
          for (final lab in r.labValues) {
            final flag = lab.abnormalFlag ? ' [ABNORMAL]' : '';
            buffer.writeln('  • ${lab.analyte}: ${lab.value} ${lab.unit} (Ref: ${lab.refLow}-${lab.refHigh})$flag');
          }
        }

        if (r.extractedText != null && r.extractedText!.isNotEmpty) {
          // Truncate long PDF raw texts to keep within token budget
          final snippet = r.extractedText!.length > 400
              ? '${r.extractedText!.substring(0, 400)}... [truncated]'
              : r.extractedText!;
          buffer.writeln('Parsed PDF Excerpt: $snippet');
        }
        buffer.writeln();
      }
    }

    var fullText = buffer.toString();
    if (fullText.length > maxCharacterBudget) {
      fullText = '${fullText.substring(0, maxCharacterBudget)}\n\n[Context truncated to budget limit]';
    }

    // Compute SHA-256 of context for caching
    final bytes = utf8.encode(fullText);
    final hash = sha256.convert(bytes).toString();

    return PatientContextBundle(
      formattedContext: fullText,
      inputHash: hash,
    );
  }
}
