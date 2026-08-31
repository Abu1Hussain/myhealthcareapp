import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens a WebAssembly SQLite database connection on Web.
///
/// Uses [WasmDatabase] with OPFS (Origin Private File System) fallback to IndexedDB.
DatabaseConnection connect({String dbName = 'myhealth_ai'}) {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      final result = await WasmDatabase.open(
        databaseName: dbName,
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}
