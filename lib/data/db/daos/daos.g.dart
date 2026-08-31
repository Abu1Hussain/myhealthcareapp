// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$UserDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PatientProfilesTable get patientProfiles => attachedDatabase.patientProfiles;
  $DepartmentsTable get departments => attachedDatabase.departments;
  $StaffProfilesTable get staffProfiles => attachedDatabase.staffProfiles;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(
          _db.attachedDatabase, _db.patientProfiles);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db.attachedDatabase, _db.departments);
  $$StaffProfilesTableTableManager get staffProfiles =>
      $$StaffProfilesTableTableManager(_db.attachedDatabase, _db.staffProfiles);
}

mixin _$AppointmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $DepartmentsTable get departments => attachedDatabase.departments;
  $AppointmentsTable get appointments => attachedDatabase.appointments;
  $ScheduleTemplatesTable get scheduleTemplates =>
      attachedDatabase.scheduleTemplates;
  $RemindersTable get reminders => attachedDatabase.reminders;
  AppointmentDaoManager get managers => AppointmentDaoManager(this);
}

class AppointmentDaoManager {
  final _$AppointmentDaoMixin _db;
  AppointmentDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db.attachedDatabase, _db.departments);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db.attachedDatabase, _db.appointments);
  $$ScheduleTemplatesTableTableManager get scheduleTemplates =>
      $$ScheduleTemplatesTableTableManager(
          _db.attachedDatabase, _db.scheduleTemplates);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db.attachedDatabase, _db.reminders);
}

mixin _$RecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $MedicalRecordsTable get medicalRecords => attachedDatabase.medicalRecords;
  $LabValuesTable get labValues => attachedDatabase.labValues;
  $VitalsTable get vitals => attachedDatabase.vitals;
  $MedicationsTable get medications => attachedDatabase.medications;
  RecordDaoManager get managers => RecordDaoManager(this);
}

class RecordDaoManager {
  final _$RecordDaoMixin _db;
  RecordDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$MedicalRecordsTableTableManager get medicalRecords =>
      $$MedicalRecordsTableTableManager(
          _db.attachedDatabase, _db.medicalRecords);
  $$LabValuesTableTableManager get labValues =>
      $$LabValuesTableTableManager(_db.attachedDatabase, _db.labValues);
  $$VitalsTableTableManager get vitals =>
      $$VitalsTableTableManager(_db.attachedDatabase, _db.vitals);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db.attachedDatabase, _db.medications);
}

mixin _$VitalsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $VitalsTable get vitals => attachedDatabase.vitals;
  $MedicationsTable get medications => attachedDatabase.medications;
  VitalsDaoManager get managers => VitalsDaoManager(this);
}

class VitalsDaoManager {
  final _$VitalsDaoMixin _db;
  VitalsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$VitalsTableTableManager get vitals =>
      $$VitalsTableTableManager(_db.attachedDatabase, _db.vitals);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db.attachedDatabase, _db.medications);
}

mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $StaffTasksTable get staffTasks => attachedDatabase.staffTasks;
  $RiskFlagsTable get riskFlags => attachedDatabase.riskFlags;
  TaskDaoManager get managers => TaskDaoManager(this);
}

class TaskDaoManager {
  final _$TaskDaoMixin _db;
  TaskDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$StaffTasksTableTableManager get staffTasks =>
      $$StaffTasksTableTableManager(_db.attachedDatabase, _db.staffTasks);
  $$RiskFlagsTableTableManager get riskFlags =>
      $$RiskFlagsTableTableManager(_db.attachedDatabase, _db.riskFlags);
}

mixin _$SystemDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $AuditLogTable get auditLog => attachedDatabase.auditLog;
  $AppSettingsTable get appSettings => attachedDatabase.appSettings;
  SystemDaoManager get managers => SystemDaoManager(this);
}

class SystemDaoManager {
  final _$SystemDaoMixin _db;
  SystemDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db.attachedDatabase, _db.auditLog);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db.attachedDatabase, _db.appSettings);
}
