import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/connection/connection.dart';
import 'package:myhealth_ai/data/db/tables/ai.dart';
import 'package:myhealth_ai/data/db/tables/appointments.dart';
import 'package:myhealth_ai/data/db/tables/records.dart';
import 'package:myhealth_ai/data/db/tables/system.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';

export 'package:myhealth_ai/data/db/tables/ai.dart';
export 'package:myhealth_ai/data/db/tables/appointments.dart';
export 'package:myhealth_ai/data/db/tables/records.dart';
export 'package:myhealth_ai/data/db/tables/system.dart';
export 'package:myhealth_ai/data/db/tables/users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  PatientProfiles,
  Departments,
  StaffProfiles,
  Appointments,
  ScheduleTemplates,
  Reminders,
  MedicalRecords,
  LabValues,
  Vitals,
  Medications,
  AiSummaries,
  RiskFlags,
  StaffTasks,
  AuditLog,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? openConnection(dbName: 'myhealth_ai.sqlite'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints in SQLite
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  /// Clears all table data (for demo resets)
  Future<void> clearAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
