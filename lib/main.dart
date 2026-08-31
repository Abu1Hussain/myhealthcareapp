import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/app.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/data/db/app_database.dart';
import 'package:myhealth_ai/data/seed/seeder.dart';

/// Application entry point.
///
/// Initializes Flutter bindings, seeds local database, and wraps the app in [ProviderScope]
/// for Riverpod dependency injection (flutter-dart-code-review §14).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  try {
    final seeder = DatabaseSeeder(db);
    await seeder.seedAll();
  } catch (e, st) {
    debugPrint('Database initialization/seeding error: $e\n$st');
  }

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const MyHealthApp(),
    ),
  );
}

