import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';

/// Clinical risk flag severity.
enum RiskSeverity {
  low,
  medium,
  high,
  critical,
}

/// Source of the detected risk flag.
enum RiskSource {
  deterministicRule,
  aiModel,
}

/// Task status lifecycle.
enum TaskStatus {
  pending,
  inProgress,
  completed,
  dismissed,
}

/// Task category kind.
enum TaskKind {
  reviewAbnormalLab,
  followUpOverdue,
  medicationRenewal,
  signClinicalNote,
  patientOutreach,
}

/// Cached AI health profile summaries (RQ1) keyed on inputHash.
class AiSummaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  DateTimeColumn get generatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get modelId => text()(); // 'claude-3-5-sonnet', 'mock-ai'
  TextColumn get promptVersion => text()(); // 'v1.0'
  TextColumn get summaryMarkdown => text()();
  TextColumn get keyEventsJson => text()(); // JSON List of {date, title, importance, category}
  TextColumn get trendsJson => text()(); // JSON List of {metric, direction, significance, chartKey}
  TextColumn get redFlagsJson => text()(); // JSON List of {flag, recommendation}
  TextColumn get inputHash => text()(); // SHA-256 of context -> eliminates duplicate API calls
}

/// Automated clinical risk flags (deterministic rules + AI analysis).
class RiskFlags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  TextColumn get kind => text().withLength(min: 2, max: 100)(); // 'Abnormal HbA1c', 'Hypertensive crisis'
  TextColumn get severity => textEnum<RiskSeverity>()();
  TextColumn get rationale => text()();
  DateTimeColumn get detectedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get source => textEnum<RiskSource>()();
  IntColumn get acknowledgedBy => integer().nullable().references(Users, #id)();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
}

/// Prioritized clinical tasks for healthcare staff (RQ3).
class StaffTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffId => integer().references(Users, #id)();
  IntColumn get patientId => integer().nullable().references(Users, #id)();
  TextColumn get title => text().withLength(min: 2, max: 200)();
  TextColumn get kind => textEnum<TaskKind>()();
  DateTimeColumn get dueAt => dateTime()();
  TextColumn get status => textEnum<TaskStatus>().withDefault(Constant(TaskStatus.pending.name))();
  RealColumn get ruleScore => real().withDefault(const Constant(0.0))(); // 0-100 deterministic
  RealColumn get aiPriorityScore => real().nullable()(); // 0-100 LLM assigned
  TextColumn get aiRationale => text().nullable()(); // Explainable rationale for defense
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
