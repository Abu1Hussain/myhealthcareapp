import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';

/// Immutable system security and access audit log.
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get actorUserId => integer().nullable().references(Users, #id)();
  TextColumn get action => text().withLength(min: 2, max: 100)(); // 'LOGIN', 'VIEW_RECORD', 'BOOK_APPOINTMENT'
  TextColumn get entityType => text().withLength(min: 2, max: 50)(); // 'Appointment', 'MedicalRecord'
  IntColumn get entityId => integer().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get metadataJson => text().nullable()(); // Additional context/IP/payload
}

/// Global application configuration (singleton row).
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get aiEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get mockMode => boolean().withDefault(const Constant(true))(); // Safe default for defense
  TextColumn get modelId => text().withDefault(const Constant('claude-3-5-sonnet-20241022'))();
  IntColumn get seedVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastSeededAt => dateTime().nullable()();
}
