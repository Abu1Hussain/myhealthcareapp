import 'package:drift/drift.dart';
import 'package:myhealth_ai/data/db/connection/connection.dart';

part 'spike_database.g.dart';

/// Minimal table to test database read/write integrity across platforms.
class SpikeLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [SpikeLogs])
class SpikeDatabase extends _$SpikeDatabase {
  SpikeDatabase([QueryExecutor? executor])
      : super(executor ?? openConnection(dbName: 'spike_test.sqlite'));

  @override
  int get schemaVersion => 1;

  /// Verifies write and read functionality on the active platform.
  Future<bool> verifyPlatformReadWrite() async {
    final msg = 'Platform spike test at ${DateTime.now().toIso8601String()}';
    final id = await into(spikeLogs).insert(
      SpikeLogsCompanion.insert(message: msg),
    );

    final row = await (select(spikeLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null && row.message == msg;
  }
}
