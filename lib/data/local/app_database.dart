import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'day_summaries_dao.dart';
import 'outdoor_sessions_dao.dart';

part 'app_database.g.dart';

class OutdoorSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get duration => integer()();
}

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

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
