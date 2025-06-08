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

abstract class TotalXpView extends View {
  DaySummaries get daySummaries;

  Expression<int> get totalXp => daySummaries.totalXp.sum();

  @override
  Query as() => select([totalXp]);
}

@DriftDatabase(
  tables: [OutdoorSessions, DaySummaries],
  daos: [OutdoorSessionsDao, DaySummariesDao],
  views: [TotalXpView],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // TODO: If ever changing schemaVersion, add onUpgrade logic
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
