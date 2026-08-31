import 'dart:math';
import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/data/db/tables/appointments.dart';
import 'package:myhealth_ai/data/db/tables/records.dart';
import 'package:myhealth_ai/data/db/tables/system.dart';
import 'package:myhealth_ai/data/db/tables/users.dart';
import 'package:myhealth_ai/data/seed/vocab/vocab.dart';
import 'package:myhealth_ai/services/auth/password_hasher.dart';

/// Correlated Synthetic Data Generator for MyHealth AI.
///
/// Uses a fixed deterministic RNG (`Random(42)`) to generate identical
/// reproducible clinical histories on any device.
class DatabaseSeeder {
  DatabaseSeeder(this.db);

  final AppDatabase db;
  final Random _rng = Random(42);

  /// Seeds all initial departments, staff, patients, records, and appointments.
  Future<void> seedAll({bool force = false}) async {
    final existingSettings = await (db.select(db.appSettings)..limit(1)).getSingleOrNull();
    if (!force && existingSettings != null && existingSettings.lastSeededAt != null) {
      return; // Already seeded
    }

    await db.transaction(() async {
      // 1. App Settings
      await _seedAppSettings();

      // 2. Admin User
      await _seedAdminUser();

      // 3. Departments
      final departmentIds = await _seedDepartments();

      // 4. Staff & Schedules
      final staffIds = await _seedStaffMembers(departmentIds);

      // 5. 60 Patients & Profiles
      final patientIds = await _seedPatients();

      // 6. 2 Years of Appointments & History
      await _seedAppointmentsAndClinicalData(patientIds, staffIds, departmentIds);
    });
  }

  Future<void> _seedAppSettings() async {
    await db.into(db.appSettings).insert(
      AppSettingsCompanion.insert(
        aiEnabled: const Value(true),
        mockMode: const Value(true),
        modelId: const Value('claude-3-5-sonnet-20241022'),
        seedVersion: const Value(1),
        lastSeededAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _seedAdminUser() async {
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword('Admin123!', salt);

    await db.into(db.users).insert(
      UsersCompanion.insert(
        role: UserRole.admin,
        fullName: 'System Administrator',
        email: 'admin@myhealth.uob',
        passwordHash: hash,
        passwordSalt: salt,
        phone: '+973 1787 3000',
        dob: DateTime(1985, 5, 15),
        gender: 'M',
        nationalId: '850515123',
      ),
    );
  }

  Future<List<int>> _seedDepartments() async {
    final ids = <int>[];
    for (final d in SeedVocab.departments) {
      final id = await db.into(db.departments).insert(
        DepartmentsCompanion.insert(
          name: d['name']!,
          description: d['description']!,
        ),
      );
      ids.add(id);
    }
    return ids;
  }

  Future<List<int>> _seedStaffMembers(List<int> departmentIds) async {
    final staffIds = <int>[];

    for (final s in SeedVocab.staffMembers) {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('Doctor123!', salt);

      final deptIndex = s['deptIndex'] as int;
      final deptId = departmentIds[deptIndex];

      final userId = await db.into(db.users).insert(
        UsersCompanion.insert(
          role: UserRole.staff,
          fullName: s['name'] as String,
          email: s['email'] as String,
          passwordHash: hash,
          passwordSalt: salt,
          phone: '+973 39${100000 + _rng.nextInt(899999)}',
          dob: DateTime(1975 + _rng.nextInt(15), 1 + _rng.nextInt(12), 1 + _rng.nextInt(28)),
          gender: s['gender'] as String,
          nationalId: '${75 + _rng.nextInt(15)}${_rng.nextInt(9999999).toString().padLeft(7, '0')}',
        ),
      );

      await db.into(db.staffProfiles).insert(
        StaffProfilesCompanion.insert(
          userId: Value(userId),
          departmentId: deptId,
          specialty: s['specialty'] as String,
          licenseNo: s['licenseNo'] as String,
          jobTitle: s['jobTitle'] as String,
        ),
      );

      // Create weekly schedule templates (Mon to Thu + Sun: 08:00 to 14:00)
      for (final weekday in [7, 1, 2, 3, 4]) {
        await db.into(db.scheduleTemplates).insert(
          ScheduleTemplatesCompanion.insert(
            staffId: userId,
            weekday: weekday,
            startTime: '08:00',
            endTime: '14:00',
            slotMinutes: const Value(30),
          ),
        );
      }

      staffIds.add(userId);
    }

    return staffIds;
  }

  Future<List<int>> _seedPatients() async {
    final patientIds = <int>[];

    // Seed specific primary demo accounts first
    final demoPatients = [
      {
        'name': 'Ali Mohamed Jaafar',
        'email': 'ali.jaafar@student.uob.bh',
        'gender': 'M',
        'cpr': '020824419',
        'dob': DateTime(2002, 8, 24),
        'conditions': ['Bronchial Asthma'],
        'allergies': ['Penicillin'],
        'blood': 'O+',
      },
      {
        'name': 'Mohammed A.Redha Meftah',
        'email': 'mohammed.meftah@student.uob.bh',
        'gender': 'M',
        'cpr': '020902781',
        'dob': DateTime(2002, 9, 2),
        'conditions': ['Type 2 Diabetes Mellitus', 'Essential Hypertension'],
        'allergies': ['None known'],
        'blood': 'A+',
      },
      {
        'name': 'Fatima Ebrahim Al-Alawi',
        'email': 'fatima.alawi@demo.bh',
        'gender': 'F',
        'cpr': '940312445',
        'dob': DateTime(1994, 3, 12),
        'conditions': ['Hyperlipidemia', 'Hypothyroidism'],
        'allergies': ['Sulfa drugs'],
        'blood': 'B+',
      },
    ];

    for (final p in demoPatients) {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('Patient123!', salt);

      final id = await db.into(db.users).insert(
        UsersCompanion.insert(
          role: UserRole.patient,
          fullName: p['name'] as String,
          email: p['email'] as String,
          passwordHash: hash,
          passwordSalt: salt,
          phone: '+973 3${_rng.nextInt(89999999).toString().padLeft(7, '0')}',
          dob: p['dob'] as DateTime,
          gender: p['gender'] as String,
          nationalId: p['cpr'] as String,
        ),
      );

      await db.into(db.patientProfiles).insert(
        PatientProfilesCompanion.insert(
          userId: Value(id),
          bloodType: p['blood'] as String,
          allergies: (p['allergies'] as List<String>).join(','),
          chronicConditions: (p['conditions'] as List<String>).join(','),
          emergencyContact: 'Family Member (+973 39123456)',
        ),
      );

      patientIds.add(id);
    }

    // Seed remaining 57 patients with realistic Bahraini name combinations
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    for (var i = patientIds.length; i < 60; i++) {
      final isMale = _rng.nextBool();
      final first = isMale
          ? SeedVocab.maleFirstNames[_rng.nextInt(SeedVocab.maleFirstNames.length)]
          : SeedVocab.femaleFirstNames[_rng.nextInt(SeedVocab.femaleFirstNames.length)]
      ;
      final family = SeedVocab.familyNames[_rng.nextInt(SeedVocab.familyNames.length)];
      final fullName = '$first $family';

      final email = '${first.toLowerCase()}.${family.toLowerCase().replaceAll('-', '')}$i@test.bh';
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('Patient123!', salt);

      final birthYear = 1955 + _rng.nextInt(48); // Ages ~23 to 71
      final dob = DateTime(birthYear, 1 + _rng.nextInt(12), 1 + _rng.nextInt(28));
      final cpr = '${birthYear.toString().substring(2)}${_rng.nextInt(8999999).toString().padLeft(7, '0')}';

      final id = await db.into(db.users).insert(
        UsersCompanion.insert(
          role: UserRole.patient,
          fullName: fullName,
          email: email,
          passwordHash: hash,
          passwordSalt: salt,
          phone: '+973 3${_rng.nextInt(89999999).toString().padLeft(7, '0')}',
          dob: dob,
          gender: isMale ? 'M' : 'F',
          nationalId: cpr,
        ),
      );

      // Chronic conditions (older patients have higher correlation)
      final conditions = <String>[];
      if (birthYear < 1975) {
        if (_rng.nextDouble() < 0.7) conditions.add('Essential Hypertension');
        if (_rng.nextDouble() < 0.6) conditions.add('Type 2 Diabetes Mellitus');
        if (_rng.nextDouble() < 0.4) conditions.add('Hyperlipidemia');
      } else if (birthYear < 1990) {
        if (_rng.nextDouble() < 0.3) conditions.add('Bronchial Asthma');
        if (_rng.nextDouble() < 0.2) conditions.add('Essential Hypertension');
      }

      final allergies = <String>[];
      if (_rng.nextDouble() < 0.25) {
        allergies.add(SeedVocab.commonAllergies[_rng.nextInt(SeedVocab.commonAllergies.length - 1)]);
      }

      await db.into(db.patientProfiles).insert(
        PatientProfilesCompanion.insert(
          userId: Value(id),
          bloodType: bloodTypes[_rng.nextInt(bloodTypes.length)],
          allergies: allergies.join(','),
          chronicConditions: conditions.join(','),
          emergencyContact: 'Emergency Contact (+973 38${_rng.nextInt(899999)})',
        ),
      );

      patientIds.add(id);
    }

    return patientIds;
  }

  Future<void> _seedAppointmentsAndClinicalData(
    List<int> patientIds,
    List<int> staffIds,
    List<int> departmentIds,
  ) async {
    final now = DateTime.now();

    for (final patientId in patientIds) {
      final profile = await (db.select(db.patientProfiles)..where((t) => t.userId.equals(patientId))).getSingle();
      final hasChronic = profile.chronicConditions.isNotEmpty;

      // Patients with chronic conditions have 8-15 appointments over 2 years; healthy patients have 2-4
      final appointmentCount = hasChronic ? (8 + _rng.nextInt(8)) : (2 + _rng.nextInt(3));

      // Each patient has an innate no-show tendency (some reliable, some habitual no-shows)
      final innateNoShowRate = _rng.nextDouble() < 0.15 ? 0.60 : 0.10;

      for (var a = 0; a < appointmentCount; a++) {
        final daysAgo = 5 + _rng.nextInt(700); // Past 2 years
        final appointmentDate = now.subtract(Duration(days: daysAgo));

        final staffId = staffIds[_rng.nextInt(staffIds.length)];
        final staffProfile = await (db.select(db.staffProfiles)..where((t) => t.userId.equals(staffId))).getSingle();
        final deptId = staffProfile.departmentId;

        final slotStart = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day, 9 + _rng.nextInt(4), _rng.nextInt(2) * 30);
        final slotEnd = slotStart.add(const Duration(minutes: 30));

        final isNoShow = _rng.nextDouble() < innateNoShowRate;
        final status = isNoShow ? AppointmentStatus.noShow : AppointmentStatus.completed;

        final apptId = await db.into(db.appointments).insert(
          AppointmentsCompanion.insert(
            patientId: patientId,
            staffId: staffId,
            departmentId: deptId,
            slotStart: slotStart,
            slotEnd: slotEnd,
            visitType: hasChronic ? 'Follow-up' : 'Routine Consultation',
            status: Value(status),
            reasonText: hasChronic ? 'Quarterly chronic condition management' : 'General medical checkup',
            noShowRisk: Value(innateNoShowRate),
            riskBand: Value(innateNoShowRate > 0.4 ? RiskBand.high : RiskBand.low),
          ),
        );

        // If completed, add clinical note, vitals, and lab values
        if (status == AppointmentStatus.completed) {
          final recordId = await db.into(db.medicalRecords).insert(
            MedicalRecordsCompanion.insert(
              patientId: patientId,
              authorStaffId: Value(staffId),
              recordType: RecordType.visitNote,
              title: 'Clinical Consultation Summary — ${slotStart.day}/${slotStart.month}/${slotStart.year}',
              body: 'Patient presented for evaluation. Vitals reviewed. Treatment adherence confirmed.',
              occurredAt: slotStart,
              sourceFacility: 'UOB Medical Center',
            ),
          );

          // Add realistic vitals
          final sys = hasChronic ? (130.0 + _rng.nextInt(25)) : (115.0 + _rng.nextInt(12));
          final dia = hasChronic ? (85.0 + _rng.nextInt(15)) : (75.0 + _rng.nextInt(10));
          final glucose = hasChronic ? (120.0 + _rng.nextInt(60)) : (85.0 + _rng.nextInt(20));

          await db.into(db.vitals).insert(
            VitalsCompanion.insert(
              patientId: patientId,
              recordedAt: slotStart,
              systolic: Value(sys),
              diastolic: Value(dia),
              heartRate: Value(68.0 + _rng.nextInt(22)),
              tempC: Value(36.6 + _rng.nextDouble() * 0.6),
              weightKg: Value(70.0 + _rng.nextInt(25)),
              heightCm: Value(165.0 + _rng.nextInt(20)),
              spo2: Value(97.0 + _rng.nextInt(3)),
              glucose: Value(glucose),
            ),
          );

          // Add lab values for chronic patients
          if (hasChronic && a % 2 == 0) {
            final hba1c = 6.2 + _rng.nextDouble() * 2.8;
            await db.into(db.labValues).insert(
              LabValuesCompanion.insert(
                recordId: recordId,
                analyte: 'HbA1c',
                value: double.parse(hba1c.toStringAsFixed(1)),
                unit: '%',
                refLow: 4.0,
                refHigh: 5.6,
                abnormalFlag: Value(hba1c > 5.6),
              ),
            );
          }
        }
      }

      // Active Medications for chronic patients
      if (hasChronic) {
        final med = SeedVocab.medicationsList[_rng.nextInt(SeedVocab.medicationsList.length)];
        await db.into(db.medications).insert(
          MedicationsCompanion.insert(
            patientId: patientId,
            prescriberId: Value(staffIds[0]),
            name: med['name']!,
            dose: med['dose']!,
            frequency: med['freq']!,
            startDate: now.subtract(const Duration(days: 180)),
            isActive: const Value(true),
          ),
        );
      }

      // Add one upcoming booked appointment in the next 14 days
      final upcomingDays = 1 + _rng.nextInt(14);
      final futureStart = DateTime(now.year, now.month, now.day + upcomingDays, 10, 0);
      await db.into(db.appointments).insert(
        AppointmentsCompanion.insert(
          patientId: patientId,
          staffId: staffIds[_rng.nextInt(staffIds.length)],
          departmentId: departmentIds[0],
          slotStart: futureStart,
          slotEnd: futureStart.add(const Duration(minutes: 30)),
          visitType: 'Scheduled Follow-up',
          status: const Value(AppointmentStatus.booked),
          reasonText: 'Routine periodic follow-up evaluation',
          noShowRisk: Value(innateNoShowRate),
          riskBand: Value(innateNoShowRate > 0.4 ? RiskBand.high : RiskBand.low),
        ),
      );
    }
  }
}
