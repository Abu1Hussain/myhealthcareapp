library;

import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/domain/entities/models.dart' as entity;
import 'package:myhealth_ai/services/ai/ai_service.dart';
import 'package:myhealth_ai/services/ai/patient_context_builder.dart';

/// Manages database caching of AI summaries keyed by SHA-256 context hash (RQ1).
class AiResultCache {
  AiResultCache({required this.db, required this.aiService});

  final AppDatabase db;
  final AiService aiService;

  /// Retrieves cached summary if inputHash matches, otherwise invokes AI service and caches result.
  Future<Result<entity.AiHealthSummary, AppFailure>> getOrGenerateSummary({
    required entity.User patient,
    required List<entity.MedicalRecord> records,
    required List<entity.VitalsRecord> vitals,
    required List<entity.Medication> medications,
    bool forceRefresh = false,
  }) async {
    final contextBundle = PatientContextBuilder.buildContext(
      patient: patient,
      records: records,
      vitals: vitals,
      medications: medications,
    );

    // 1. Check local Drift cache unless forceRefresh is requested
    if (!forceRefresh) {
      final cached = await (db.select(db.aiSummaries)
            ..where((t) =>
                t.patientId.equals(patient.id) &
                t.inputHash.equals(contextBundle.inputHash))
            ..limit(1))
          .getSingleOrNull();

      if (cached != null) {
        return Success(_mapRowToEntity(cached));
      }
    }

    // 2. Invoke AI Service
    final result = await aiService.generateSummary(
      patient: patient,
      records: records,
      vitals: vitals,
      medications: medications,
    );

    return result.fold(
      (summary) async {
        // 3. Save generated summary into Drift cache
        final id = await db.into(db.aiSummaries).insert(
              AiSummariesCompanion.insert(
                patientId: summary.patientId,
                modelId: summary.modelId,
                promptVersion: summary.promptVersion,
                summaryMarkdown: summary.summaryMarkdown,
                keyEventsJson: jsonEncode(
                  summary.keyEvents
                      .map(
                        (e) => {
                          'date': e.date,
                          'title': e.title,
                          'category': e.category,
                          'importance': e.importance,
                        },
                      )
                      .toList(),
                ),
                trendsJson: jsonEncode(
                  summary.trends
                      .map(
                        (t) => {
                          'metric': t.metric,
                          'direction': t.direction,
                          'significance': t.significance,
                          'chartKey': t.chartKey,
                        },
                      )
                      .toList(),
                ),
                redFlagsJson: jsonEncode(summary.redFlags),
                inputHash: contextBundle.inputHash,
              ),
            );

        return Success(
          entity.AiHealthSummary(
            id: id,
            patientId: summary.patientId,
            generatedAt: summary.generatedAt,
            modelId: summary.modelId,
            promptVersion: summary.promptVersion,
            summaryMarkdown: summary.summaryMarkdown,
            keyEvents: summary.keyEvents,
            trends: summary.trends,
            redFlags: summary.redFlags,
            inputHash: contextBundle.inputHash,
          ),
        );
      },
      (failure) => Failure(failure),
    );
  }

  entity.AiHealthSummary _mapRowToEntity(AiSummary row) {
    List<entity.AiKeyEvent> keyEvents = [];
    try {
      final list = jsonDecode(row.keyEventsJson) as List<dynamic>;
      keyEvents = list
          .map(
            (e) => entity.AiKeyEvent(
              date: e['date']?.toString() ?? '',
              title: e['title']?.toString() ?? '',
              category: e['category']?.toString() ?? 'General',
              importance: e['importance']?.toString() ?? 'Routine',
            ),
          )
          .toList();
    } catch (_) {}

    List<entity.AiTrend> trends = [];
    try {
      final list = jsonDecode(row.trendsJson) as List<dynamic>;
      trends = list
          .map(
            (t) => entity.AiTrend(
              metric: t['metric']?.toString() ?? '',
              direction: t['direction']?.toString() ?? 'stable',
              significance: t['significance']?.toString() ?? '',
              chartKey: t['chartKey']?.toString() ?? 'bp',
            ),
          )
          .toList();
    } catch (_) {}

    List<String> redFlags = [];
    try {
      final list = jsonDecode(row.redFlagsJson) as List<dynamic>;
      redFlags = list.map((r) => r.toString()).toList();
    } catch (_) {}

    return entity.AiHealthSummary(
      id: row.id,
      patientId: row.patientId,
      generatedAt: row.generatedAt,
      modelId: row.modelId,
      promptVersion: row.promptVersion,
      summaryMarkdown: row.summaryMarkdown,
      keyEvents: keyEvents,
      trends: trends,
      redFlags: redFlags,
      inputHash: row.inputHash,
    );
  }
}
