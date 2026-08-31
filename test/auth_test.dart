import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/data/seed/seeder.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/services/auth/password_hasher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    final seeder = DatabaseSeeder(db);
    await seeder.seedAll(force: true);
  });

  tearDown(() async {
    await db.close();
  });

  test('AuthController login with valid patient succeeds', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(authControllerProvider.notifier);
    final success = await controller.login(
      'ali.jaafar@student.uob.bh',
      'Patient123!',
    );

    expect(success, isTrue);
    final currentUser = container.read(currentUserProvider);
    expect(currentUser, isNotNull);
    expect(currentUser!.fullName, equals('Ali Mohamed Jaafar'));
  });

  test('PasswordHasher verifies password correctly', () {
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword('CorrectPass123!', salt);

    expect(PasswordHasher.verify('CorrectPass123!', salt, hash), isTrue);
    expect(PasswordHasher.verify('WrongPass!', salt, hash), isFalse);
  });
}
