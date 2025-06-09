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

  /// Watch (stream) the summary for a given dateId.
  Stream<DaySummary?> watchByDateId(int dateId) =>
      (select(daySummaries)..where((tbl) => tbl.dateId.equals(dateId))).watchSingleOrNull();

  /// Watch (stream) total XP (across all days).
  Stream<int> watchTotalXp() => customSelect(
    'SELECT COALESCE(SUM(total_xp), 0) AS xp FROM day_summaries',
    readsFrom: {daySummaries},
  ).watchSingle().map((row) => row.read<int>('xp'));

  /// Watch (stream) total minutes for a given day.
  Stream<int> watchTotalMinutesForDay(int dateId) => customSelect(
    'SELECT COALESCE(total_minutes, 0) AS minutes FROM day_summaries WHERE date_id = ?',
    variables: [Variable<int>(dateId)],
    readsFrom: {daySummaries},
  ).watchSingle().map((row) => row.read<int>('minutes'));
}
