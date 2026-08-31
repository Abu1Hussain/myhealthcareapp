library;

/// Pure domain entities for MyHealth AI.
/// Completely decoupled from Drift/SQLite and JSON serialization details.
/// Immutable data structures with value equality.


// ── User & Profiles ───────────────────────────────────────────────────

enum UserRole { patient, staff, admin }

class User {
  const User({
    required this.id,
    required this.role,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.nationalId,
    required this.isActive,
    required this.createdAt,
    this.patientProfile,
    this.staffProfile,
  });

  final int id;
  final UserRole role;
  final String fullName;
  final String email;
  final String phone;
  final DateTime dob;
  final String gender;
  final String nationalId;
  final bool isActive;
  final DateTime createdAt;
  final PatientProfile? patientProfile;
  final StaffProfile? staffProfile;

  int get age => DateTime.now().year - dob.year;
}

class PatientProfile {
  const PatientProfile({
    required this.userId,
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContact,
  });

  final int userId;
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String emergencyContact;
}

class StaffProfile {
  const StaffProfile({
    required this.userId,
    required this.departmentId,
    required this.specialty,
    required this.licenseNo,
    required this.jobTitle,
    this.departmentName,
  });

  final int userId;
  final int departmentId;
  final String specialty;
  final String licenseNo;
  final String jobTitle;
  final String? departmentName;
}

class Department {
  const Department({
    required this.id,
    required this.name,
    required this.description,
  });

  final int id;
  final String name;
  final String description;
}

// ── Appointments & Schedule ───────────────────────────────────────────

enum AppointmentStatus { booked, confirmed, checkedIn, completed, cancelled, noShow }
enum RiskBand { low, medium, high }

class Appointment {
  const Appointment({
    required this.id,
    required this.patientId,
    required this.staffId,
    required this.departmentId,
    required this.slotStart,
    required this.slotEnd,
    required this.visitType,
    required this.status,
    required this.reasonText,
    required this.bookedAt,
    this.noShowRisk,
    this.riskBand,
    this.remindersSent = 0,
    this.checkedInAt,
    this.patientName,
    this.doctorName,
    this.departmentName,
  });

  final int id;
  final int patientId;
  final int staffId;
  final int departmentId;
  final DateTime slotStart;
  final DateTime slotEnd;
  final String visitType;
  final AppointmentStatus status;
  final String reasonText;
  final DateTime bookedAt;
  final double? noShowRisk;
  final RiskBand? riskBand;
  final int remindersSent;
  final DateTime? checkedInAt;
  final String? patientName;
  final String? doctorName;
  final String? departmentName;
}

class ScheduleSlot {
  const ScheduleSlot({
    required this.staffId,
    required this.departmentId,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.predictedRisk,
    this.recommendationScore,
    this.recommendationReason,
  });

  final int staffId;
  final int departmentId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final double? predictedRisk;
  final double? recommendationScore;
  final String? recommendationReason;
}

// ── Medical Records & Timeline ─────────────────────────────────────────

enum RecordType {
  visitNote,
  consultationNote,
  labResult,
  labReport,
  imaging,
  imagingReport,
  prescription,
  vaccination,
  dischargeSummary,
  referral,
}

class MedicalRecord {
  const MedicalRecord({
    required this.id,
    required this.patientId,
    this.authorStaffId,
    required this.recordType,
    required this.title,
    required this.body,
    required this.occurredAt,
    required this.sourceFacility,
    this.attachmentPath,
    this.extractedText,
    this.createdAt,
    this.labValues = const [],
    this.authorName,
  });

  final int id;
  final int patientId;
  final int? authorStaffId;
  final RecordType recordType;
  final String title;
  final String body;
  final DateTime occurredAt;
  final String sourceFacility;
  final String? attachmentPath;
  final String? extractedText;
  final DateTime? createdAt;
  final List<LabValue> labValues;
  final String? authorName;
}

class LabValue {
  const LabValue({
    required this.id,
    required this.recordId,
    required this.analyte,
    required this.value,
    required this.unit,
    required this.refLow,
    required this.refHigh,
    required this.abnormalFlag,
  });

  final int id;
  final int recordId;
  final String analyte;
  final double value;
  final String unit;
  final double refLow;
  final double refHigh;
  final bool abnormalFlag;
}

class VitalsRecord {
  const VitalsRecord({
    required this.id,
    required this.patientId,
    required this.recordedAt,
    this.systolic,
    this.diastolic,
    this.heartRate,
    this.tempC,
    this.weightKg,
    this.heightCm,
    this.spo2,
    this.glucose,
  });

  final int id;
  final int patientId;
  final DateTime recordedAt;
  final double? systolic;
  final double? diastolic;
  final double? heartRate;
  final double? tempC;
  final double? weightKg;
  final double? heightCm;
  final double? spo2;
  final double? glucose;
}

class Medication {
  const Medication({
    required this.id,
    required this.patientId,
    this.prescriberId,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.prescriberName,
  });

  final int id;
  final int patientId;
  final int? prescriberId;
  final String name;
  final String dose;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? prescriberName;
}

// ── AI Summaries & Tasks ───────────────────────────────────────────────

class AiKeyEvent {
  const AiKeyEvent({
    required this.date,
    required this.title,
    required this.category,
    required this.importance,
  });

  final String date;
  final String title;
  final String category;
  final String importance; // 'High', 'Medium', 'Routine'
}

class AiTrend {
  const AiTrend({
    required this.metric,
    required this.direction, // 'improving', 'worsening', 'stable'
    required this.significance,
    required this.chartKey, // 'bp', 'glucose', 'weight'
  });

  final String metric;
  final String direction;
  final String significance;
  final String chartKey;
}

class AiHealthSummary {
  const AiHealthSummary({
    required this.id,
    required this.patientId,
    required this.generatedAt,
    required this.modelId,
    required this.promptVersion,
    required this.summaryMarkdown,
    required this.keyEvents,
    required this.trends,
    required this.redFlags,
    required this.inputHash,
  });

  final int id;
  final int patientId;
  final DateTime generatedAt;
  final String modelId;
  final String promptVersion;
  final String summaryMarkdown;
  final List<AiKeyEvent> keyEvents;
  final List<AiTrend> trends;
  final List<String> redFlags;
  final String inputHash;
}

enum RiskSeverity { low, medium, high, critical }
enum RiskSource { deterministicRule, aiModel }

class RiskFlagItem {
  const RiskFlagItem({
    required this.id,
    required this.patientId,
    required this.kind,
    required this.severity,
    required this.rationale,
    required this.detectedAt,
    required this.source,
    this.acknowledgedBy,
    this.acknowledgedAt,
    this.patientName,
  });

  final int id;
  final int patientId;
  final String kind;
  final RiskSeverity severity;
  final String rationale;
  final DateTime detectedAt;
  final RiskSource source;
  final int? acknowledgedBy;
  final DateTime? acknowledgedAt;
  final String? patientName;
}

enum TaskStatus { pending, inProgress, completed, dismissed }
enum TaskKind {
  reviewAbnormalLab,
  followUpOverdue,
  medicationRenewal,
  signClinicalNote,
  patientOutreach,
}

class StaffTaskItem {
  const StaffTaskItem({
    required this.id,
    required this.staffId,
    this.patientId,
    required this.title,
    required this.kind,
    required this.dueAt,
    required this.status,
    required this.ruleScore,
    this.aiPriorityScore,
    this.aiRationale,
    required this.createdAt,
    this.patientName,
  });

  final int id;
  final int staffId;
  final int? patientId;
  final String title;
  final TaskKind kind;
  final DateTime dueAt;
  final TaskStatus status;
  final double ruleScore;
  final double? aiPriorityScore;
  final String? aiRationale;
  final DateTime createdAt;
  final String? patientName;

  double get blendedPriority =>
      (aiPriorityScore != null) ? (ruleScore * 0.4 + aiPriorityScore! * 0.6) : ruleScore;
}

// ── System & Audit ─────────────────────────────────────────────────────

class AuditEntry {
  const AuditEntry({
    required this.id,
    this.actorUserId,
    required this.action,
    required this.entityType,
    this.entityId,
    required this.timestamp,
    this.metadataJson,
    this.actorName,
  });

  final int id;
  final int? actorUserId;
  final String action;
  final String entityType;
  final int? entityId;
  final DateTime timestamp;
  final String? metadataJson;
  final String? actorName;
}

class AppSettingsState {
  const AppSettingsState({
    required this.aiEnabled,
    required this.mockMode,
    required this.modelId,
    required this.seedVersion,
    this.lastSeededAt,
  });

  final bool aiEnabled;
  final bool mockMode;
  final String modelId;
  final int seedVersion;
  final DateTime? lastSeededAt;
}
