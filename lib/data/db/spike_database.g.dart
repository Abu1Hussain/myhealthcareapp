// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spike_database.dart';

// ignore_for_file: type=lint
class $SpikeLogsTable extends SpikeLogs
    with TableInfo<$SpikeLogsTable, SpikeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpikeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, message, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spike_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SpikeLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpikeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpikeLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SpikeLogsTable createAlias(String alias) {
    return $SpikeLogsTable(attachedDatabase, alias);
  }
}

class SpikeLog extends DataClass implements Insertable<SpikeLog> {
  final int id;
  final String message;
  final DateTime createdAt;
  const SpikeLog(
      {required this.id, required this.message, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SpikeLogsCompanion toCompanion(bool nullToAbsent) {
    return SpikeLogsCompanion(
      id: Value(id),
      message: Value(message),
      createdAt: Value(createdAt),
    );
  }

  factory SpikeLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpikeLog(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SpikeLog copyWith({int? id, String? message, DateTime? createdAt}) =>
      SpikeLog(
        id: id ?? this.id,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
      );
  SpikeLog copyWithCompanion(SpikeLogsCompanion data) {
    return SpikeLog(
      id: data.id.present ? data.id.value : this.id,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpikeLog(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpikeLog &&
          other.id == this.id &&
          other.message == this.message &&
          other.createdAt == this.createdAt);
}

class SpikeLogsCompanion extends UpdateCompanion<SpikeLog> {
  final Value<int> id;
  final Value<String> message;
  final Value<DateTime> createdAt;
  const SpikeLogsCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SpikeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    this.createdAt = const Value.absent(),
  }) : message = Value(message);
  static Insertable<SpikeLog> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SpikeLogsCompanion copyWith(
      {Value<int>? id, Value<String>? message, Value<DateTime>? createdAt}) {
    return SpikeLogsCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpikeLogsCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$SpikeDatabase extends GeneratedDatabase {
  _$SpikeDatabase(QueryExecutor e) : super(e);
  $SpikeDatabaseManager get managers => $SpikeDatabaseManager(this);
  late final $SpikeLogsTable spikeLogs = $SpikeLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [spikeLogs];
}

typedef $$SpikeLogsTableCreateCompanionBuilder = SpikeLogsCompanion Function({
  Value<int> id,
  required String message,
  Value<DateTime> createdAt,
});
typedef $$SpikeLogsTableUpdateCompanionBuilder = SpikeLogsCompanion Function({
  Value<int> id,
  Value<String> message,
  Value<DateTime> createdAt,
});

class $$SpikeLogsTableFilterComposer
    extends Composer<_$SpikeDatabase, $SpikeLogsTable> {
  $$SpikeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SpikeLogsTableOrderingComposer
    extends Composer<_$SpikeDatabase, $SpikeLogsTable> {
  $$SpikeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SpikeLogsTableAnnotationComposer
    extends Composer<_$SpikeDatabase, $SpikeLogsTable> {
  $$SpikeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SpikeLogsTableTableManager extends RootTableManager<
    _$SpikeDatabase,
    $SpikeLogsTable,
    SpikeLog,
    $$SpikeLogsTableFilterComposer,
    $$SpikeLogsTableOrderingComposer,
    $$SpikeLogsTableAnnotationComposer,
    $$SpikeLogsTableCreateCompanionBuilder,
    $$SpikeLogsTableUpdateCompanionBuilder,
    (SpikeLog, BaseReferences<_$SpikeDatabase, $SpikeLogsTable, SpikeLog>),
    SpikeLog,
    PrefetchHooks Function()> {
  $$SpikeLogsTableTableManager(_$SpikeDatabase db, $SpikeLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpikeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpikeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpikeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SpikeLogsCompanion(
            id: id,
            message: message,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String message,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SpikeLogsCompanion.insert(
            id: id,
            message: message,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpikeLogsTableProcessedTableManager = ProcessedTableManager<
    _$SpikeDatabase,
    $SpikeLogsTable,
    SpikeLog,
    $$SpikeLogsTableFilterComposer,
    $$SpikeLogsTableOrderingComposer,
    $$SpikeLogsTableAnnotationComposer,
    $$SpikeLogsTableCreateCompanionBuilder,
    $$SpikeLogsTableUpdateCompanionBuilder,
    (SpikeLog, BaseReferences<_$SpikeDatabase, $SpikeLogsTable, SpikeLog>),
    SpikeLog,
    PrefetchHooks Function()>;

class $SpikeDatabaseManager {
  final _$SpikeDatabase _db;
  $SpikeDatabaseManager(this._db);
  $$SpikeLogsTableTableManager get spikeLogs =>
      $$SpikeLogsTableTableManager(_db, _db.spikeLogs);
}
