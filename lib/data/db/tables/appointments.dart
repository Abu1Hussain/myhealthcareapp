import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';

/// Appointment status lifecycle.
enum AppointmentStatus {
  booked,
  confirmed,
  completed,
  cancelled,
  noShow,
}

/// Risk bands for no-show and prioritization.
enum RiskBand {
  low,
  medium,
  high,
}

/// Reminder channels.
enum ReminderChannel {
  pushNotification,
  sms,
  inAppBanner,
}

/// Reminder kind for risk-adaptive escalation.
enum ReminderKind {
  standard,
  escalated,
  confirmOrRelease,
}

/// Appointment table with ML prediction score columns.
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Users, #id)();
  IntColumn get staffId => integer().references(Users, #id)();
  IntColumn get departmentId => integer().references(Departments, #id)();
  DateTimeColumn get slotStart => dateTime()();
  DateTimeColumn get slotEnd => dateTime()();
  TextColumn get visitType => text().withLength(min: 2, max: 50)(); // 'Routine', 'Follow-up', 'Consultation'
  TextColumn get status => textEnum<AppointmentStatus>().withDefault(Constant(AppointmentStatus.booked.name))();
  TextColumn get reasonText => text()();
  DateTimeColumn get bookedAt => dateTime().withDefault(currentDateAndTime)();
  
  // ML No-Show Prediction columns (RQ2)
  RealColumn get noShowRisk => real().nullable()(); // 0.0 to 1.0 probability
  TextColumn get riskBand => textEnum<RiskBand>().nullable()();
  IntColumn get remindersSent => integer().withDefault(const Constant(0))();
  DateTimeColumn get checkedInAt => dateTime().nullable()();
}

/// Recurring doctor schedule templates for slot generation.
class ScheduleTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffId => integer().references(Users, #id)();
  IntColumn get weekday => integer()(); // 1 (Monday) to 7 (Sunday)
  TextColumn get startTime => text()(); // '08:00'
  TextColumn get endTime => text()(); // '14:00'
  IntColumn get slotMinutes => integer().withDefault(const Constant(30))();
}

/// Risk-adaptive reminders generated for upcoming visits.
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get appointmentId => integer().references(Appointments, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get scheduledFor => dateTime()();
  TextColumn get channel => textEnum<ReminderChannel>()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  TextColumn get kind => textEnum<ReminderKind>()();
}
