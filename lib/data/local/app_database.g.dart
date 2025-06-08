// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OutdoorSessionsTable extends OutdoorSessions
    with TableInfo<$OutdoorSessionsTable, OutdoorSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutdoorSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startTime, endTime, duration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outdoor_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutdoorSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutdoorSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutdoorSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
    );
  }

  @override
  $OutdoorSessionsTable createAlias(String alias) {
    return $OutdoorSessionsTable(attachedDatabase, alias);
  }
}

class OutdoorSession extends DataClass implements Insertable<OutdoorSession> {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  const OutdoorSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['duration'] = Variable<int>(duration);
    return map;
  }

  OutdoorSessionsCompanion toCompanion(bool nullToAbsent) {
    return OutdoorSessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: Value(endTime),
      duration: Value(duration),
    );
  }

  factory OutdoorSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutdoorSession(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      duration: serializer.fromJson<int>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'duration': serializer.toJson<int>(duration),
    };
  }

  OutdoorSession copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
  }) => OutdoorSession(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    duration: duration ?? this.duration,
  );
  OutdoorSession copyWithCompanion(OutdoorSessionsCompanion data) {
    return OutdoorSession(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutdoorSession(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startTime, endTime, duration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutdoorSession &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration);
}

class OutdoorSessionsCompanion extends UpdateCompanion<OutdoorSession> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> duration;
  const OutdoorSessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
  });
  OutdoorSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    required int duration,
  }) : startTime = Value(startTime),
       endTime = Value(endTime),
       duration = Value(duration);
  static Insertable<OutdoorSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
    });
  }

  OutdoorSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? duration,
  }) {
    return OutdoorSessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutdoorSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }
}

class $DaySummariesTable extends DaySummaries
    with TableInfo<$DaySummariesTable, DaySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateIdMeta = const VerificationMeta('dateId');
  @override
  late final GeneratedColumn<int> dateId = GeneratedColumn<int>(
    'date_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dateId, totalMinutes, totalXp, streak];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DaySummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_id')) {
      context.handle(
        _dateIdMeta,
        dateId.isAcceptableOrUnknown(data['date_id']!, _dateIdMeta),
      );
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalMinutesMeta);
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    } else if (isInserting) {
      context.missing(_totalXpMeta);
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    } else if (isInserting) {
      context.missing(_streakMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateId};
  @override
  DaySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DaySummary(
      dateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_id'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
    );
  }

  @override
  $DaySummariesTable createAlias(String alias) {
    return $DaySummariesTable(attachedDatabase, alias);
  }
}

class DaySummary extends DataClass implements Insertable<DaySummary> {
  final int dateId;
  final int totalMinutes;
  final int totalXp;
  final int streak;
  const DaySummary({
    required this.dateId,
    required this.totalMinutes,
    required this.totalXp,
    required this.streak,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_id'] = Variable<int>(dateId);
    map['total_minutes'] = Variable<int>(totalMinutes);
    map['total_xp'] = Variable<int>(totalXp);
    map['streak'] = Variable<int>(streak);
    return map;
  }

  DaySummariesCompanion toCompanion(bool nullToAbsent) {
    return DaySummariesCompanion(
      dateId: Value(dateId),
      totalMinutes: Value(totalMinutes),
      totalXp: Value(totalXp),
      streak: Value(streak),
    );
  }

  factory DaySummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DaySummary(
      dateId: serializer.fromJson<int>(json['dateId']),
      totalMinutes: serializer.fromJson<int>(json['totalMinutes']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      streak: serializer.fromJson<int>(json['streak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateId': serializer.toJson<int>(dateId),
      'totalMinutes': serializer.toJson<int>(totalMinutes),
      'totalXp': serializer.toJson<int>(totalXp),
      'streak': serializer.toJson<int>(streak),
    };
  }

  DaySummary copyWith({
    int? dateId,
    int? totalMinutes,
    int? totalXp,
    int? streak,
  }) => DaySummary(
    dateId: dateId ?? this.dateId,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    totalXp: totalXp ?? this.totalXp,
    streak: streak ?? this.streak,
  );
  DaySummary copyWithCompanion(DaySummariesCompanion data) {
    return DaySummary(
      dateId: data.dateId.present ? data.dateId.value : this.dateId,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      streak: data.streak.present ? data.streak.value : this.streak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DaySummary(')
          ..write('dateId: $dateId, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('totalXp: $totalXp, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dateId, totalMinutes, totalXp, streak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DaySummary &&
          other.dateId == this.dateId &&
          other.totalMinutes == this.totalMinutes &&
          other.totalXp == this.totalXp &&
          other.streak == this.streak);
}

class DaySummariesCompanion extends UpdateCompanion<DaySummary> {
  final Value<int> dateId;
  final Value<int> totalMinutes;
  final Value<int> totalXp;
  final Value<int> streak;
  const DaySummariesCompanion({
    this.dateId = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.streak = const Value.absent(),
  });
  DaySummariesCompanion.insert({
    this.dateId = const Value.absent(),
    required int totalMinutes,
    required int totalXp,
    required int streak,
  }) : totalMinutes = Value(totalMinutes),
       totalXp = Value(totalXp),
       streak = Value(streak);
  static Insertable<DaySummary> custom({
    Expression<int>? dateId,
    Expression<int>? totalMinutes,
    Expression<int>? totalXp,
    Expression<int>? streak,
  }) {
    return RawValuesInsertable({
      if (dateId != null) 'date_id': dateId,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (totalXp != null) 'total_xp': totalXp,
      if (streak != null) 'streak': streak,
    });
  }

  DaySummariesCompanion copyWith({
    Value<int>? dateId,
    Value<int>? totalMinutes,
    Value<int>? totalXp,
    Value<int>? streak,
  }) {
    return DaySummariesCompanion(
      dateId: dateId ?? this.dateId,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      totalXp: totalXp ?? this.totalXp,
      streak: streak ?? this.streak,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateId.present) {
      map['date_id'] = Variable<int>(dateId.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaySummariesCompanion(')
          ..write('dateId: $dateId, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('totalXp: $totalXp, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OutdoorSessionsTable outdoorSessions = $OutdoorSessionsTable(
    this,
  );
  late final $DaySummariesTable daySummaries = $DaySummariesTable(this);
  late final OutdoorSessionsDao outdoorSessionsDao = OutdoorSessionsDao(
    this as AppDatabase,
  );
  late final DaySummariesDao daySummariesDao = DaySummariesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outdoorSessions,
    daySummaries,
  ];
}

typedef $$OutdoorSessionsTableCreateCompanionBuilder =
    OutdoorSessionsCompanion Function({
      Value<int> id,
      required DateTime startTime,
      required DateTime endTime,
      required int duration,
    });
typedef $$OutdoorSessionsTableUpdateCompanionBuilder =
    OutdoorSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> duration,
    });

class $$OutdoorSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $OutdoorSessionsTable> {
  $$OutdoorSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutdoorSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutdoorSessionsTable> {
  $$OutdoorSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutdoorSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutdoorSessionsTable> {
  $$OutdoorSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);
}

class $$OutdoorSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutdoorSessionsTable,
          OutdoorSession,
          $$OutdoorSessionsTableFilterComposer,
          $$OutdoorSessionsTableOrderingComposer,
          $$OutdoorSessionsTableAnnotationComposer,
          $$OutdoorSessionsTableCreateCompanionBuilder,
          $$OutdoorSessionsTableUpdateCompanionBuilder,
          (
            OutdoorSession,
            BaseReferences<
              _$AppDatabase,
              $OutdoorSessionsTable,
              OutdoorSession
            >,
          ),
          OutdoorSession,
          PrefetchHooks Function()
        > {
  $$OutdoorSessionsTableTableManager(
    _$AppDatabase db,
    $OutdoorSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutdoorSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutdoorSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutdoorSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
              }) => OutdoorSessionsCompanion(
                id: id,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                required int duration,
              }) => OutdoorSessionsCompanion.insert(
                id: id,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutdoorSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutdoorSessionsTable,
      OutdoorSession,
      $$OutdoorSessionsTableFilterComposer,
      $$OutdoorSessionsTableOrderingComposer,
      $$OutdoorSessionsTableAnnotationComposer,
      $$OutdoorSessionsTableCreateCompanionBuilder,
      $$OutdoorSessionsTableUpdateCompanionBuilder,
      (
        OutdoorSession,
        BaseReferences<_$AppDatabase, $OutdoorSessionsTable, OutdoorSession>,
      ),
      OutdoorSession,
      PrefetchHooks Function()
    >;
typedef $$DaySummariesTableCreateCompanionBuilder =
    DaySummariesCompanion Function({
      Value<int> dateId,
      required int totalMinutes,
      required int totalXp,
      required int streak,
    });
typedef $$DaySummariesTableUpdateCompanionBuilder =
    DaySummariesCompanion Function({
      Value<int> dateId,
      Value<int> totalMinutes,
      Value<int> totalXp,
      Value<int> streak,
    });

class $$DaySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dateId => $composableBuilder(
    column: $table.dateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DaySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dateId => $composableBuilder(
    column: $table.dateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DaySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dateId =>
      $composableBuilder(column: $table.dateId, builder: (column) => column);

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);
}

class $$DaySummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DaySummariesTable,
          DaySummary,
          $$DaySummariesTableFilterComposer,
          $$DaySummariesTableOrderingComposer,
          $$DaySummariesTableAnnotationComposer,
          $$DaySummariesTableCreateCompanionBuilder,
          $$DaySummariesTableUpdateCompanionBuilder,
          (
            DaySummary,
            BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummary>,
          ),
          DaySummary,
          PrefetchHooks Function()
        > {
  $$DaySummariesTableTableManager(_$AppDatabase db, $DaySummariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dateId = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> streak = const Value.absent(),
              }) => DaySummariesCompanion(
                dateId: dateId,
                totalMinutes: totalMinutes,
                totalXp: totalXp,
                streak: streak,
              ),
          createCompanionCallback:
              ({
                Value<int> dateId = const Value.absent(),
                required int totalMinutes,
                required int totalXp,
                required int streak,
              }) => DaySummariesCompanion.insert(
                dateId: dateId,
                totalMinutes: totalMinutes,
                totalXp: totalXp,
                streak: streak,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DaySummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DaySummariesTable,
      DaySummary,
      $$DaySummariesTableFilterComposer,
      $$DaySummariesTableOrderingComposer,
      $$DaySummariesTableAnnotationComposer,
      $$DaySummariesTableCreateCompanionBuilder,
      $$DaySummariesTableUpdateCompanionBuilder,
      (
        DaySummary,
        BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummary>,
      ),
      DaySummary,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OutdoorSessionsTableTableManager get outdoorSessions =>
      $$OutdoorSessionsTableTableManager(_db, _db.outdoorSessions);
  $$DaySummariesTableTableManager get daySummaries =>
      $$DaySummariesTableTableManager(_db, _db.daySummaries);
}
