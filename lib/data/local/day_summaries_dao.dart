import 'package:drift/drift.dart';

import 'app_database.dart';

part 'day_summaries_dao.g.dart';

@DriftAccessor(tables: [DaySummaries])
class DaySummariesDao extends DatabaseAccessor<AppDatabase>
    with _$DaySummariesDaoMixin {
  DaySummariesDao(super.db);

  /// Insert or update (upsert) a summary.
  Future<void> upsertDaySummary(DaySummariesCompanion entry) =>
      into(daySummaries).insertOnConflictUpdate(entry);

  /// Get a summary by its dateId.
  Future<DaySummary?> getByDateId(int dateId) => (select(
    daySummaries,
  )..where((tbl) => tbl.dateId.equals(dateId))).getSingleOrNull();

  /// Watch (stream) the summary for a given dateId.
  Stream<DaySummary?> watchByDateId(int dateId) => (select(
    daySummaries,
  )..where((tbl) => tbl.dateId.equals(dateId))).watchSingleOrNull();

  /// Watch (stream) total XP (across all days).
  Stream<int> watchTotalXp() => select(
    daySummaries,
  ).watch().map((rows) => rows.fold(0, (sum, row) => sum + row.totalXp));

  /// Watch (stream) total minutes for a given day.
  Stream<int> watchTotalMinutesForDay(int dateId) =>
      (select(daySummaries)..where((tbl) => tbl.dateId.equals(dateId)))
          .watchSingleOrNull()
          .map((summary) => summary?.totalMinutes ?? 0);
}
