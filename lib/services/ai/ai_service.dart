library;

import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Abstract AI Service contract for clinical summarization and triage (RQ1).
///
/// Implementations:
/// - [MockAiService]: Deterministic offline fallback (defense insurance).
/// - [ClaudeAiService]: Anthropic Messages API client (Claude 3.5 Sonnet).
abstract class AiService {
  /// Generates a structured clinical health summary from patient timeline data.
  Future<Result<AiHealthSummary, AppFailure>> generateSummary({
    required User patient,
    required List<MedicalRecord> records,
    required List<VitalsRecord> vitals,
    required List<Medication> medications,
    String? customPrompt,
  });

  /// The model identifier (e.g. 'claude-3-5-sonnet-20241022' or 'mock-ai-v1').
  String get modelId;

  /// Prompt version string for audit trails.
  String get promptVersion;
}
