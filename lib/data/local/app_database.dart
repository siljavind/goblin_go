import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'day_summaries_dao.dart';
import 'outdoor_sessions_dao.dart';

part 'app_database.g.dart';

/// Table for storing each outdoor session.
class OutdoorSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get duration => integer()();
}

/// Table for storing day summary data.
class DaySummaries extends Table {
  IntColumn get dateId => integer()(); // 'YYYYMMDD'
  IntColumn get totalMinutes => integer()();
  IntColumn get totalXp => integer()();
  IntColumn get streak => integer()();

  @override
  Set<Column> get primaryKey => {dateId};
}

@DriftDatabase(tables: [OutdoorSessions, DaySummaries], daos: [OutdoorSessionsDao, DaySummariesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(outdoorSessions, outdoorSessions.duration);
      }
    },
    onCreate: (m) => m.createAll(),
  );
}

//TODO: Necessary?
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
