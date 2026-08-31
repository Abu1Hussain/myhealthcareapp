import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/domain/entities/models.dart';

/// Pure domain repository interfaces for MyHealth AI.
///
/// Principles:
/// - ZERO imports from Drift or database libraries (pure domain contracts).
/// - All methods return `Result<T, AppFailure>` to enforce compile-time error handling.
/// - Allows swapping SQLite for a REST/gRPC backend in future without touching business logic.

// ── Auth Repository ───────────────────────────────────────────────────

abstract class AuthRepository {
  Future<Result<User, AppFailure>> login({
    required String email,
    required String password,
  });

  Future<Result<User, AppFailure>> registerPatient({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required DateTime dob,
    required String gender,
    required String nationalId,
    required String bloodType,
    required List<String> allergies,
    required List<String> chronicConditions,
    required String emergencyContact,
  });

  Future<Result<void, AppFailure>> logout();

  Future<Result<User?, AppFailure>> getCurrentUser();
}

// ── User Repository ───────────────────────────────────────────────────

abstract class UserRepository {
  Future<Result<User, AppFailure>> getUserById(int id);

  Future<Result<List<User>, AppFailure>> getStaffMembers({int? departmentId});

  Future<Result<List<User>, AppFailure>> searchPatients({required String query});

  Future<Result<List<Department>, AppFailure>> getDepartments();

  Future<Result<User, AppFailure>> createStaff({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required DateTime dob,
    required String gender,
    required String nationalId,
    required int departmentId,
    required String specialty,
    required String licenseNo,
    required String jobTitle,
  });

  Future<Result<void, AppFailure>> toggleUserActive(int userId, bool isActive);
}

// ── Appointment Repository ────────────────────────────────────────────

abstract class AppointmentRepository {
  Future<Result<List<Appointment>, AppFailure>> getAppointmentsForPatient(int patientId);

  Future<Result<List<Appointment>, AppFailure>> getAppointmentsForStaff(
    int staffId, {
    DateTime? date,
  });

  Future<Result<List<Appointment>, AppFailure>> getAppointmentsForDoctor(
    int doctorId, {
    DateTime? date,
  });

  Future<Result<List<ScheduleSlot>, AppFailure>> getAvailableSlots({
    required int staffId,
    required int departmentId,
    required DateTime date,
  });

  Future<Result<Appointment, AppFailure>> bookAppointment({
    required int patientId,
    required int staffId,
    required int departmentId,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String visitType,
    required String reasonText,
    double? predictedNoShowRisk,
    RiskBand? riskBand,
  });

  Future<Result<void, AppFailure>> updateAppointmentStatus(
    int appointmentId,
    AppointmentStatus status,
  );

  Future<Result<void, AppFailure>> cancelAppointment(int appointmentId);

  Future<Result<void, AppFailure>> rescheduleAppointment(
    int appointmentId,
    DateTime newStart,
    DateTime newEnd,
  );
}

// ── Medical Record & Timeline Repository ──────────────────────────────

abstract class RecordRepository {
  Future<Result<List<MedicalRecord>, AppFailure>> getTimelineForPatient(
    int patientId, {
    RecordType? filterType,
    String? searchQuery,
    int limit = 50,
    int offset = 0,
  });

  Future<Result<MedicalRecord, AppFailure>> getRecordById(int recordId);

  Future<Result<MedicalRecord, AppFailure>> addClinicalNote({
    required int patientId,
    required int authorStaffId,
    required RecordType recordType,
    required String title,
    required String body,
    required DateTime occurredAt,
    required String sourceFacility,
    List<LabValue> labValues = const [],
  });

  Future<Result<MedicalRecord, AppFailure>> importPdfRecord({
    required int patientId,
    required String title,
    required String localPdfPath,
    required String extractedText,
    required DateTime occurredAt,
    required String sourceFacility,
  });
}

// ── Vitals & Medication Repository ────────────────────────────────────

abstract class VitalsRepository {
  Future<Result<List<VitalsRecord>, AppFailure>> getVitalsHistory(
    int patientId, {
    int limit = 30,
  });

  Future<Result<VitalsRecord, AppFailure>> logVitals({
    required int patientId,
    required DateTime recordedAt,
    double? systolic,
    double? diastolic,
    double? heartRate,
    double? tempC,
    double? weightKg,
    double? heightCm,
    double? spo2,
    double? glucose,
  });

  Future<Result<List<Medication>, AppFailure>> getMedicationsForPatient(
    int patientId, {
    bool activeOnly = false,
  });

  Future<Result<Medication, AppFailure>> prescribeMedication({
    required int patientId,
    required int prescriberId,
    required String name,
    required String dose,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
  });
}

// ── Task & Risk Repository ────────────────────────────────────────────

abstract class TaskRepository {
  Future<Result<List<StaffTaskItem>, AppFailure>> getTasksForStaff(
    int staffId, {
    TaskStatus? status,
  });

  Future<Result<StaffTaskItem, AppFailure>> createTask({
    required int staffId,
    int? patientId,
    required String title,
    required TaskKind kind,
    required DateTime dueAt,
    required double ruleScore,
  });

  Future<Result<void, AppFailure>> updateTaskStatus(
    int taskId,
    TaskStatus status,
  );

  Future<Result<void, AppFailure>> updateTaskAiPriority(
    int taskId,
    double aiScore,
    String aiRationale,
  );
}

abstract class RiskRepository {
  Future<Result<List<RiskFlagItem>, AppFailure>> getActiveRiskFlags({int? patientId});

  Future<Result<RiskFlagItem, AppFailure>> createRiskFlag({
    required int patientId,
    required String kind,
    required RiskSeverity severity,
    required String rationale,
    required RiskSource source,
  });

  Future<Result<void, AppFailure>> acknowledgeRiskFlag(
    int flagId,
    int staffUserId,
  );
}

// ── Admin & System Repository ─────────────────────────────────────────

abstract class AdminRepository {
  Future<Result<List<AuditEntry>, AppFailure>> getAuditLogs({int limit = 100});

  Future<Result<void, AppFailure>> logAudit({
    int? actorUserId,
    required String action,
    required String entityType,
    int? entityId,
    String? metadataJson,
  });

  Future<Result<AppSettingsState, AppFailure>> getAppSettings();

  Future<Result<void, AppFailure>> updateAppSettings({
    bool? aiEnabled,
    bool? mockMode,
    String? modelId,
  });

  Future<Result<void, AppFailure>> resetDatabaseToSeed();
}
