import 'package:drift/drift.dart';

import 'app_database.dart';

part 'day_summaries_dao.g.dart';

@DriftAccessor(tables: [DaySummaries])
class DaySummariesDao extends DatabaseAccessor<AppDatabase> with _$DaySummariesDaoMixin {
  DaySummariesDao(super.db);

  /// Insert or update (upsert) a summary.
  Future<void> upsertDaySummary(DaySummariesCompanion entry) =>
      into(daySummaries).insertOnConflictUpdate(entry);

  /// Get a summary by its dateId.
  Future<DaySummary?> getByDateId(int dateId) =>
      (select(daySummaries)..where((tbl) => tbl.dateId.equals(dateId))).getSingleOrNull();

  Future<int> getTotalMinutesForDay(DateTime date) async {
    int dateId = _dateToDateId(date);
    return (select(daySummaries)..where((tbl) => tbl.dateId.equals(dateId))).getSingleOrNull().then(
      (summary) => summary?.totalMinutes ?? 0,
    );
  }

  /// Watch (stream) the summary for a given dateId.
  Stream<DaySummary?> watchByDateId(int dateId) =>
      (select(daySummaries)..where((tbl) => tbl.dateId.equals(dateId))).watchSingleOrNull();

  /// Watch (stream) total XP (across all days).
  Stream<int> watchTotalXp() =>
      select(daySummaries).watch().map((rows) => rows.fold<int>(0, (sum, r) => sum + r.totalXp));

  /// Watch (stream) total minutes for a given day.
  Stream<int> watchTotalMinutesForDay(int dateId) =>
      watchByDateId(dateId).map((row) => row?.totalMinutes ?? 0);
}

//TODO Refactor usage in other places to send dates, not dateIds
int _dateToDateId(DateTime d) => d.year * 10000 + d.month * 100 + d.day;
