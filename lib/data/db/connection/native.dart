import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens a native SQLite connection on Windows, Android, and iOS.
///
/// Uses [getApplicationDocumentsDirectory] to ensure the database
/// file is persisted across app restarts on mobile and desktop.
DatabaseConnection connect({String dbName = 'myhealth_ai.sqlite'}) {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, dbName));
      return NativeDatabase.createBackgroundConnection(file);
    }),
  );
}
