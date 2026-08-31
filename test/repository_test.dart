import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/data/db/daos/daos.dart';
import 'package:myhealth_ai/data/repositories/repository_impls.dart';
import 'package:myhealth_ai/data/seed/seeder.dart';
import 'package:myhealth_ai/domain/entities/models.dart' as entity;
import 'package:myhealth_ai/services/auth/password_hasher.dart';

void main() {
  late AppDatabase db;
  late UserDao userDao;
  late AppointmentDao appointmentDao;
  late RecordDao recordDao;
  late VitalsDao vitalsDao;
  late TaskDao taskDao;
  late SystemDao systemDao;

  late AdminRepositoryImpl adminRepo;
  late AuthRepositoryImpl authRepo;
  late UserRepositoryImpl userRepo;
  late AppointmentRepositoryImpl appointmentRepo;
  late RecordRepositoryImpl recordRepo;
  late VitalsRepositoryImpl vitalsRepo;
  late TaskRepositoryImpl taskRepo;
  late RiskRepositoryImpl riskRepo;

  setUp(() async {
    // In-memory SQLite database for rapid, isolated testing
    db = AppDatabase(NativeDatabase.memory());
    userDao = UserDao(db);
    appointmentDao = AppointmentDao(db);
    recordDao = RecordDao(db);
    vitalsDao = VitalsDao(db);
    taskDao = TaskDao(db);
    systemDao = SystemDao(db);

    adminRepo = AdminRepositoryImpl(systemDao: systemDao, appDatabase: db);
    authRepo = AuthRepositoryImpl(userDao: userDao, adminRepo: adminRepo);
    userRepo = UserRepositoryImpl(userDao: userDao);
    appointmentRepo = AppointmentRepositoryImpl(
      appointmentDao: appointmentDao,
      userDao: userDao,
      adminRepo: adminRepo,
    );
    recordRepo = RecordRepositoryImpl(
      recordDao: recordDao,
      userDao: userDao,
      adminRepo: adminRepo,
    );
    vitalsRepo = VitalsRepositoryImpl(vitalsDao: vitalsDao);
    taskRepo = TaskRepositoryImpl(taskDao: taskDao);
    riskRepo = RiskRepositoryImpl(taskDao: taskDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Password Hasher Tests', () {
    test('generateSalt returns 16-byte base64 string', () {
      final salt = PasswordHasher.generateSalt();
      expect(salt.isNotEmpty, isTrue);
    });

    test('hash and verify match for correct password and reject wrong password', () {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('MySecurePassword123!', salt);

      expect(PasswordHasher.verify('MySecurePassword123!', salt, hash), isTrue);
      expect(PasswordHasher.verify('WrongPassword', salt, hash), isFalse);
    });
  });

  group('Database Seeder & Repositories Integration Tests', () {
    test('Seeder generates 5 departments, 12 staff, and 60 patients', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedAll(force: true);

      // Verify departments
      final deptsResult = await userRepo.getDepartments();
      expect(deptsResult.isSuccess, isTrue);
      expect(deptsResult.value.length, equals(5));

      // Verify staff members
      final staffResult = await userRepo.getStaffMembers();
      expect(staffResult.isSuccess, isTrue);
      expect(staffResult.value.length, equals(12));

      // Verify patients
      final patientsResult = await userRepo.searchPatients(query: '');
      expect(patientsResult.isSuccess, isTrue);
      expect(patientsResult.value.length, equals(60));
    });

    test('AuthRepository authenticates valid seeded patient', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedAll(force: true);

      // Try login with seeded demo patient
      final result = await authRepo.login(
        email: 'ali.jaafar@student.uob.bh',
        password: 'Patient123!',
      );

      expect(result.isSuccess, isTrue);
      expect(result.value.fullName, equals('Ali Mohamed Jaafar'));
      expect(result.value.role, equals(entity.UserRole.patient));
      expect(result.value.patientProfile?.chronicConditions, contains('Bronchial Asthma'));
    });

    test('PasswordHasher verifies valid and invalid passwords', () {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('Secret123!', salt);

      expect(PasswordHasher.verify('Secret123!', salt, hash), isTrue);
      expect(PasswordHasher.verify('WrongSecret!', salt, hash), isFalse);
    });

    test('RecordRepository fetches patient timeline', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedAll(force: true);

      // Find first patient
      final patients = (await userRepo.searchPatients(query: 'Mohammed')).value;
      final patient = patients.first;

      final timeline = await recordRepo.getTimelineForPatient(patient.id);
      expect(timeline.isSuccess, isTrue);
      expect(timeline.value.isNotEmpty, isTrue);
    });

    test('AppointmentRepository calculates available doctor schedule slots', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedAll(force: true);

      final staff = (await userRepo.getStaffMembers()).value.first;

      // Next Monday
      final now = DateTime.now();
      final daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
      final nextMonday = now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));

      final slotsResult = await appointmentRepo.getAvailableSlots(
        staffId: staff.id,
        departmentId: staff.staffProfile!.departmentId,
        date: nextMonday,
      );

      expect(slotsResult.isSuccess, isTrue);
      expect(slotsResult.value.isNotEmpty, isTrue);
    });
  });
}
