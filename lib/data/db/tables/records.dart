import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';

/// Clinical record type categorization.
enum RecordType {
  visitNote,
  labResult,
  imaging,
  prescription,
  vaccination,
  dischargeSummary,
  referral,
}

/// Heterogeneous medical records forming the unified patient timeline.
class MedicalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  IntColumn get authorStaffId => integer().nullable().references(Users, #id)();
  TextColumn get recordType => textEnum<RecordType>()();
  TextColumn get title => text().withLength(min: 2, max: 200)();
  TextColumn get body => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get sourceFacility => text().withLength(min: 2, max: 100)();
  TextColumn get attachmentPath => text().nullable()(); // Path to local PDF / image
  TextColumn get extractedText => text().nullable()(); // Plain text from PDF (RQ1)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Structured laboratory values linked to medical records.
class LabValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer().references(MedicalRecords, #id, onDelete: KeyAction.cascade)();
  TextColumn get analyte => text().withLength(min: 1, max: 100)(); // 'HbA1c', 'Glucose', etc.
  RealColumn get value => real()();
  TextColumn get unit => text().withLength(min: 1, max: 50)(); // 'mg/dL', '%', 'mmol/L'
  RealColumn get refLow => real()();
  RealColumn get refHigh => real()();
  BoolColumn get abnormalFlag => boolean().withDefault(const Constant(false))();
}

/// Time-series vitals observations.
class Vitals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  DateTimeColumn get recordedAt => dateTime()();
  RealColumn get systolic => real().nullable()(); // mmHg
  RealColumn get diastolic => real().nullable()(); // mmHg
  RealColumn get heartRate => real().nullable()(); // bpm
  RealColumn get tempC => real().nullable()(); // Celsius
  RealColumn get weightKg => real().nullable()(); // kg
  RealColumn get heightCm => real().nullable()(); // cm
  RealColumn get spo2 => real().nullable()(); // %
  RealColumn get glucose => real().nullable()(); // mg/dL
}

/// Patient medications.
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  IntColumn get prescriberId => integer().nullable().references(Users, #id)();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get dose => text().withLength(min: 1, max: 50)(); // '500mg'
  TextColumn get frequency => text().withLength(min: 1, max: 50)(); // 'Twice daily'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
