import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/app_database.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Users, PatientProfiles, StaffProfiles, Departments])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<User?> getUserById(int id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<User?> getUserByEmail(String email) =>
      (select(users)..where((t) => t.email.equals(email))).getSingleOrNull();

  Future<PatientProfile?> getPatientProfile(int userId) =>
      (select(patientProfiles)..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<StaffProfile?> getStaffProfile(int userId) =>
      (select(staffProfiles)..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<List<User>> getAllStaff({int? departmentId}) async {
    if (departmentId == null) {
      return (select(users)..where((t) => t.role.equals(UserRole.staff.name))).get();
    }
    final query = select(users).join([
      innerJoin(staffProfiles, staffProfiles.userId.equalsExp(users.id)),
    ])..where(staffProfiles.departmentId.equals(departmentId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(users)).toList();
  }

  Future<List<User>> searchPatients(String query) {
    final lower = '%${query.toLowerCase()}%';
    return (select(users)
          ..where((t) =>
              t.role.equals(UserRole.patient.name) &
              (t.fullName.lower().like(lower) |
                  t.email.lower().like(lower) |
                  t.nationalId.like(lower))))
        .get();
  }

  Future<List<Department>> getDepartments() => select(departments).get();

  Future<int> insertUser(UsersCompanion companion) => into(users).insert(companion);

  Future<void> insertPatientProfile(PatientProfilesCompanion companion) =>
      into(patientProfiles).insert(companion);

  Future<void> insertStaffProfile(StaffProfilesCompanion companion) =>
      into(staffProfiles).insert(companion);

  Future<void> updateUserActive(int userId, bool isActive) =>
      (update(users)..where((t) => t.id.equals(userId)))
          .write(UsersCompanion(isActive: Value(isActive)));
}

@DriftAccessor(tables: [Appointments, ScheduleTemplates, Reminders, Users, Departments])
class AppointmentDao extends DatabaseAccessor<AppDatabase> with _$AppointmentDaoMixin {
  AppointmentDao(super.db);

  Future<List<Appointment>> getPatientAppointments(int patientId) =>
      (select(appointments)
            ..where((t) => t.patientId.equals(patientId))
            ..orderBy([(t) => OrderingTerm.desc(t.slotStart)]))
          .get();

  Future<List<Appointment>> getStaffAppointments(int staffId, {DateTime? date}) {
    var query = select(appointments)..where((t) => t.staffId.equals(staffId));
    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
      query = query..where((t) => t.slotStart.isBiggerOrEqualValue(start) & t.slotStart.isSmallerOrEqualValue(end));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.slotStart)])).get();
  }

  Future<List<ScheduleTemplate>> getTemplatesForStaff(int staffId) =>
      (select(scheduleTemplates)..where((t) => t.staffId.equals(staffId))).get();

  Future<int> insertAppointment(AppointmentsCompanion companion) =>
      into(appointments).insert(companion);

  Future<void> updateStatus(int appointmentId, AppointmentStatus status) =>
      (update(appointments)..where((t) => t.id.equals(appointmentId)))
          .write(AppointmentsCompanion(status: Value(status)));

  Future<void> reschedule(int appointmentId, DateTime newStart, DateTime newEnd) =>
      (update(appointments)..where((t) => t.id.equals(appointmentId)))
          .write(AppointmentsCompanion(
        slotStart: Value(newStart),
        slotEnd: Value(newEnd),
        status: const Value(AppointmentStatus.booked),
      ));
}

@DriftAccessor(tables: [MedicalRecords, LabValues, Vitals, Medications, Users])
class RecordDao extends DatabaseAccessor<AppDatabase> with _$RecordDaoMixin {
  RecordDao(super.db);

  Future<List<MedicalRecord>> getPatientRecords(
    int patientId, {
    String? recordType,
    String? searchQuery,
    int limit = 50,
    int offset = 0,
  }) {
    var query = select(medicalRecords)..where((t) => t.patientId.equals(patientId));
    if (recordType != null) {
      query = query..where((t) => t.recordType.equals(recordType));
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final lower = '%${searchQuery.toLowerCase()}%';
      query = query..where((t) => t.title.lower().like(lower) | t.body.lower().like(lower));
    }
    return (query
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<MedicalRecord?> getRecordById(int id) =>
      (select(medicalRecords)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<LabValue>> getLabValuesForRecord(int recordId) =>
      (select(labValues)..where((t) => t.recordId.equals(recordId))).get();

  Future<int> insertRecord(MedicalRecordsCompanion companion) =>
      into(medicalRecords).insert(companion);

  Future<int> insertLabValue(LabValuesCompanion companion) =>
      into(labValues).insert(companion);
}

@DriftAccessor(tables: [Vitals, Medications, Users])
class VitalsDao extends DatabaseAccessor<AppDatabase> with _$VitalsDaoMixin {
  VitalsDao(super.db);

  Future<List<Vital>> getVitalsHistory(int patientId, {int limit = 30}) =>
      (select(vitals)
            ..where((t) => t.patientId.equals(patientId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(limit))
          .get();

  Future<int> insertVitals(VitalsCompanion companion) => into(vitals).insert(companion);

  Future<List<Medication>> getMedications(int patientId, {bool activeOnly = false}) {
    var query = select(medications)..where((t) => t.patientId.equals(patientId));
    if (activeOnly) {
      query = query..where((t) => t.isActive.equals(true));
    }
    return (query..orderBy([(t) => OrderingTerm.desc(t.startDate)])).get();
  }

  Future<int> insertMedication(MedicationsCompanion companion) =>
      into(medications).insert(companion);
}

@DriftAccessor(tables: [StaffTasks, RiskFlags, Users])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<List<StaffTask>> getStaffTasks(int staffId, {String? status}) {
    var query = select(staffTasks)..where((t) => t.staffId.equals(staffId));
    if (status != null) {
      query = query..where((t) => t.status.equals(status));
    }
    return (query..orderBy([(t) => OrderingTerm.asc(t.dueAt)])).get();
  }

  Future<int> insertTask(StaffTasksCompanion companion) => into(staffTasks).insert(companion);

  Future<void> updateTaskStatus(int taskId, TaskStatus status) =>
      (update(staffTasks)..where((t) => t.id.equals(taskId)))
          .write(StaffTasksCompanion(status: Value(status)));

  Future<void> updateTaskAiScore(int taskId, double aiScore, String aiRationale) =>
      (update(staffTasks)..where((t) => t.id.equals(taskId)))
          .write(StaffTasksCompanion(
        aiPriorityScore: Value(aiScore),
        aiRationale: Value(aiRationale),
      ));

  Future<List<RiskFlag>> getRiskFlags({int? patientId}) {
    var query = select(riskFlags);
    if (patientId != null) {
      query = query..where((t) => t.patientId.equals(patientId));
    }
    return (query..orderBy([(t) => OrderingTerm.desc(t.detectedAt)])).get();
  }

  Future<int> insertRiskFlag(RiskFlagsCompanion companion) =>
      into(riskFlags).insert(companion);

  Future<void> acknowledgeRiskFlag(int flagId, int staffUserId) =>
      (update(riskFlags)..where((t) => t.id.equals(flagId))).write(RiskFlagsCompanion(
        acknowledgedBy: Value(staffUserId),
        acknowledgedAt: Value(DateTime.now()),
      ));
}

@DriftAccessor(tables: [AuditLog, AppSettings])
class SystemDao extends DatabaseAccessor<AppDatabase> with _$SystemDaoMixin {
  SystemDao(super.db);

  Future<List<AuditLogData>> getAuditLogs({int limit = 100}) =>
      (select(auditLog)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])..limit(limit)).get();

  Future<int> insertAudit(AuditLogCompanion companion) => into(auditLog).insert(companion);

  Future<AppSetting?> getSettings() =>
      (select(appSettings)..limit(1)).getSingleOrNull();

  Future<void> updateSettings(AppSettingsCompanion companion) async {
    final existing = await getSettings();
    if (existing == null) {
      await into(appSettings).insert(companion);
    } else {
      await (update(appSettings)..where((t) => t.id.equals(existing.id))).write(companion);
    }
  }
}
