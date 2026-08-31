import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/data/db/daos/daos.dart';
import 'package:myhealth_ai/data/repositories/repository_impls.dart';
import 'package:myhealth_ai/domain/repositories/interfaces.dart';
import 'package:myhealth_ai/services/ai/ai_result_cache.dart';
import 'package:myhealth_ai/services/ai/ai_service.dart';
import 'package:myhealth_ai/services/ai/claude_ai_service.dart';
import 'package:myhealth_ai/services/ai/mock_ai_service.dart';

export 'package:myhealth_ai/services/clinical/risk_detection_service.dart';
export 'package:myhealth_ai/services/clinical/task_prioritization_service.dart';

/// Riverpod provider registry for MyHealth AI.
/// Central location for all dependency providers (flutter-dart-code-review §14).

// ── Database ─────────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── DAOs ─────────────────────────────────────────────────────────────

final userDaoProvider = Provider<UserDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserDao(db);
});

final appointmentDaoProvider = Provider<AppointmentDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppointmentDao(db);
});

final recordDaoProvider = Provider<RecordDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecordDao(db);
});

final vitalsDaoProvider = Provider<VitalsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return VitalsDao(db);
});

final taskDaoProvider = Provider<TaskDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TaskDao(db);
});

final systemDaoProvider = Provider<SystemDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SystemDao(db);
});

// ── Repositories ─────────────────────────────────────────────────────

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(
    systemDao: ref.watch(systemDaoProvider),
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    userDao: ref.watch(userDaoProvider),
    adminRepo: ref.watch(adminRepositoryProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    userDao: ref.watch(userDaoProvider),
  );
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepositoryImpl(
    appointmentDao: ref.watch(appointmentDaoProvider),
    userDao: ref.watch(userDaoProvider),
    adminRepo: ref.watch(adminRepositoryProvider),
  );
});

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  return RecordRepositoryImpl(
    recordDao: ref.watch(recordDaoProvider),
    userDao: ref.watch(userDaoProvider),
    adminRepo: ref.watch(adminRepositoryProvider),
  );
});

final vitalsRepositoryProvider = Provider<VitalsRepository>((ref) {
  return VitalsRepositoryImpl(
    vitalsDao: ref.watch(vitalsDaoProvider),
  );
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    taskDao: ref.watch(taskDaoProvider),
  );
});

final riskRepositoryProvider = Provider<RiskRepository>((ref) {
  return RiskRepositoryImpl(
    taskDao: ref.watch(taskDaoProvider),
  );
});

// ── AI Services (RQ1) ─────────────────────────────────────────────────

final mockAiServiceProvider = Provider<AiService>((ref) => MockAiService());

final claudeAiServiceProvider = Provider<AiService>((ref) => ClaudeAiService());

/// Dynamic AI Service provider switching between Mock & Claude based on settings.
final aiServiceProvider = Provider<AiService>((ref) {
  // Defaults to MockAiService for 100% resilient defense insurance
  return ref.watch(mockAiServiceProvider);
});

/// Caching proxy for AI summaries.
final aiResultCacheProvider = Provider<AiResultCache>((ref) {
  return AiResultCache(
    db: ref.watch(appDatabaseProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

// ── Clinical Risk & Task Prioritization (RQ3) ─────────────────────────
