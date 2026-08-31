import 'package:drift/drift.dart';

/// User roles supported in the system.
enum UserRole {
  patient,
  staff,
  admin,
}

/// Core users table with salted password hash authentication.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => textEnum<UserRole>()();
  TextColumn get fullName => text().withLength(min: 2, max: 100)();
  TextColumn get email => text().unique().withLength(min: 5, max: 100)();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  TextColumn get phone => text().withLength(min: 8, max: 20)();
  DateTimeColumn get dob => dateTime()();
  TextColumn get gender => text().withLength(min: 1, max: 10)(); // 'M', 'F'
  TextColumn get nationalId => text().unique().withLength(min: 9, max: 20)(); // CPR
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Clinical patient profiles linked 1:1 to Users.
class PatientProfiles extends Table {
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get bloodType => text().withLength(min: 2, max: 5)(); // A+, O-, etc.
  TextColumn get allergies => text()(); // Comma-separated or JSON list
  TextColumn get chronicConditions => text()(); // Comma-separated or JSON list
  TextColumn get emergencyContact => text()(); // JSON string {name, relation, phone}

  @override
  Set<Column> get primaryKey => {userId};
}

/// Medical departments in the clinic.
class Departments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 2, max: 100)();
  TextColumn get description => text()();
}

/// Medical staff profiles linked 1:1 to Users.
class StaffProfiles extends Table {
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get departmentId => integer().references(Departments, #id)();
  TextColumn get specialty => text().withLength(min: 2, max: 100)();
  TextColumn get licenseNo => text().unique().withLength(min: 3, max: 50)();
  TextColumn get jobTitle => text().withLength(min: 2, max: 100)(); // Consultant, Resident, Nurse

  @override
  Set<Column> get primaryKey => {userId};
}
