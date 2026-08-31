import 'package:drift/drift.dart' hide Table, Column, Index;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/data/db/app_database.dart'
    hide User, PatientProfile, MedicalRecord, Medication, UserRole, RecordType;
import 'package:myhealth_ai/data/db/tables/users.dart' as db_user;
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/ai/ai_result_cache.dart';
import 'package:myhealth_ai/services/ai/mock_ai_service.dart';
import 'package:myhealth_ai/services/ai/patient_context_builder.dart';

void main() {
  final testPatient = User(
    id: 1,
    role: UserRole.patient,
    fullName: 'Ali Mohamed Jaafar',
    email: 'ali.jaafar@student.uob.bh',
    phone: '+973 39123456',
    dob: DateTime(2002, 8, 24),
    gender: 'M',
    nationalId: '020824419',
    isActive: true,
    createdAt: DateTime.now(),
    patientProfile: const PatientProfile(
      userId: 1,
      bloodType: 'O+',
      allergies: ['Penicillin'],
      chronicConditions: ['Bronchial Asthma'],
      emergencyContact: 'Family (+973 39112233)',
    ),
  );

  group('PatientContextBuilder Tests', () {
    test('buildContext formats demographics and calculates SHA-256 hash', () {
      final bundle = PatientContextBuilder.buildContext(
        patient: testPatient,
        records: [],
        vitals: [],
        medications: [],
      );

      expect(bundle.formattedContext, contains('Ali Mohamed Jaafar'));
      expect(bundle.formattedContext, contains('Bronchial Asthma'));
      expect(bundle.formattedContext, contains('Penicillin'));
      expect(bundle.inputHash.isNotEmpty, isTrue);
      expect(bundle.inputHash.length, equals(64)); // SHA-256 hex string length
    });
  });

  group('MockAiService Tests', () {
    test('generateSummary produces structured summary with key events and trends', () async {
      final mockService = MockAiService();
      final result = await mockService.generateSummary(
        patient: testPatient,
        records: [
          MedicalRecord(
            id: 1,
            patientId: 1,
            recordType: RecordType.visitNote,
            title: 'Asthma Follow-up',
            body: 'Patient reports well-controlled asthma with salbutamol as needed.',
            occurredAt: DateTime.now(),
            sourceFacility: 'UOB Clinic',
          ),
        ],
        vitals: [
          VitalsRecord(
            id: 1,
            patientId: 1,
            recordedAt: DateTime.now(),
            systolic: 118,
            diastolic: 76,
            heartRate: 72,
          ),
        ],
        medications: [
          Medication(
            id: 1,
            patientId: 1,
            name: 'Ventolin Inhaler',
            dose: '100mcg',
            frequency: '2 puffs as needed',
            startDate: DateTime.now(),
            isActive: true,
          ),
        ],
      );

      expect(result.isSuccess, isTrue);
      final summary = result.value;
      expect(summary.modelId, equals('mock-ai-v1'));
      expect(summary.summaryMarkdown.isNotEmpty, isTrue);
      expect(summary.trends.isNotEmpty, isTrue);
      expect(summary.keyEvents.isNotEmpty, isTrue);
    });
  });

  group('AiResultCache Tests', () {
    test('getOrGenerateSummary caches output and returns cached row on second call', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final mockService = MockAiService();
      final cache = AiResultCache(db: db, aiService: mockService);

      // Seed patient row for foreign key
      await db.into(db.users).insert(
            UsersCompanion.insert(
              id: const Value(1),
              role: db_user.UserRole.patient,
              fullName: testPatient.fullName,
              email: testPatient.email,
              passwordHash: 'hash',
              passwordSalt: 'salt',
              phone: testPatient.phone,
              dob: testPatient.dob,
              gender: testPatient.gender,
              nationalId: testPatient.nationalId,
            ),
          );

      // 1. First call (generates and caches)
      final result1 = await cache.getOrGenerateSummary(
        patient: testPatient,
        records: [],
        vitals: [],
        medications: [],
      );

      expect(result1.isSuccess, isTrue);
      final generatedId = result1.value.id;

      // 2. Second call with identical context (hits Drift cache)
      final result2 = await cache.getOrGenerateSummary(
        patient: testPatient,
        records: [],
        vitals: [],
        medications: [],
      );

      expect(result2.isSuccess, isTrue);
      expect(result2.value.id, equals(generatedId));
      expect(result2.value.inputHash, equals(result1.value.inputHash));

      await db.close();
    });
  });
}
