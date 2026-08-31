library;

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/ai/ai_service.dart';
import 'package:myhealth_ai/services/ai/patient_context_builder.dart';
import 'package:myhealth_ai/services/ai/prompts/summarize_records.dart';
import 'package:myhealth_ai/services/ai/secure_key_storage.dart';

/// Live Anthropic Claude AI summarization client (Claude 3.5 Sonnet).
class ClaudeAiService implements AiService {
  ClaudeAiService({Dio? dioClient})
      : _dio = dioClient ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.anthropic.com/v1',
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 40),
                headers: {
                  'anthropic-version': '2023-06-01',
                  'content-type': 'application/json',
                },
              ),
            );

  final Dio _dio;

  @override
  String get modelId => 'claude-3-5-sonnet-20241022';

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
    try {
      final apiKey = await SecureKeyStorage.getAnthropicApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        return const Failure(
          AiServiceFailure(
            message: 'Anthropic API key is not configured. Please add your key in Admin AI Settings or enable Mock Mode.',
          ),
        );
      }

      final contextBundle = PatientContextBuilder.buildContext(
        patient: patient,
        records: records,
        vitals: vitals,
        medications: medications,
      );

      final userPrompt = customPrompt ?? SummarizeRecordsPrompt.buildUserPrompt(contextBundle.formattedContext);

      final response = await _dio.post(
        '/messages',
        options: Options(headers: {'x-api-key': apiKey}),
        data: {
          'model': modelId,
          'max_tokens': 2048,
          'system': SummarizeRecordsPrompt.systemInstruction,
          'messages': [
            {'role': 'user', 'content': userPrompt}
          ],
        },
      );

      if (response.statusCode != 200) {
        return Failure(
          AiServiceFailure(
            message: 'Claude API responded with status ${response.statusCode}: ${response.statusMessage}',
          ),
        );
      }

      final data = response.data as Map<String, dynamic>;
      final contentList = data['content'] as List<dynamic>;
      if (contentList.isEmpty) {
        return const Failure(AiParsingFailure());
      }

      final textBlock = contentList.first as Map<String, dynamic>;
      final rawText = (textBlock['text'] as String).trim();

      // Clean JSON if model included markdown fences
      var cleanJson = rawText;
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      }
      if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3);
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }
      cleanJson = cleanJson.trim();

      final parsed = jsonDecode(cleanJson) as Map<String, dynamic>;

      final keyEvents = (parsed['keyEvents'] as List<dynamic>?)
              ?.map(
                (e) => AiKeyEvent(
                  date: e['date']?.toString() ?? '',
                  title: e['title']?.toString() ?? '',
                  category: e['category']?.toString() ?? 'General',
                  importance: e['importance']?.toString() ?? 'Routine',
                ),
              )
              .toList() ??
          [];

      final trends = (parsed['trends'] as List<dynamic>?)
              ?.map(
                (t) => AiTrend(
                  metric: t['metric']?.toString() ?? '',
                  direction: t['direction']?.toString() ?? 'stable',
                  significance: t['significance']?.toString() ?? '',
                  chartKey: t['chartKey']?.toString() ?? 'bp',
                ),
              )
              .toList() ??
          [];

      final redFlags = (parsed['redFlags'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [];

      final summary = AiHealthSummary(
        id: 0,
        patientId: patient.id,
        generatedAt: DateTime.now(),
        modelId: modelId,
        promptVersion: promptVersion,
        summaryMarkdown: parsed['summaryMarkdown']?.toString() ?? rawText,
        keyEvents: keyEvents,
        trends: trends,
        redFlags: redFlags,
        inputHash: contextBundle.inputHash,
      );

      return Success(summary);
    } on DioException catch (e, st) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Failure(AiTimeoutFailure());
      }
      return Failure(
        AiServiceFailure(
          message: 'Claude API connection failed: ${e.message}',
          stackTrace: st,
        ),
      );
    } catch (_) {
      return const Failure(
        AiParsingFailure(),
      );
    }
  }

  /// Convenience static helper to retrieve stored API key.
  static Future<String?> loadApiKey() => SecureKeyStorage.getAnthropicApiKey();

  /// Convenience static helper to store API key.
  static Future<void> saveApiKey(String key) => SecureKeyStorage.saveAnthropicApiKey(key);
}
