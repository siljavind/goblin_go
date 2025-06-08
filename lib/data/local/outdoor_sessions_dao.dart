import 'package:drift/drift.dart';

import 'app_database.dart';

part 'outdoor_sessions_dao.g.dart';

@DriftAccessor(tables: [OutdoorSessions])
class OutdoorSessionsDao extends DatabaseAccessor<AppDatabase>
    with _$OutdoorSessionsDaoMixin {
  OutdoorSessionsDao(super.db);

  Future<int> insertSession(OutdoorSessionsCompanion entry) =>
      into(outdoorSessions).insert(entry);

  /// Gets all sessions for a given day as a Future List.
  Future<List<OutdoorSession>> getSessionsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(outdoorSessions)..where(
          (tbl) =>
              tbl.startTime.isBiggerOrEqualValue(start) &
              tbl.startTime.isSmallerThanValue(end),
        ))
        .get();
  }

  /// Watches (streams) all sessions for a given day.
  Stream<List<OutdoorSession>> watchSessionsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(outdoorSessions)..where(
          (tbl) =>
              tbl.startTime.isBiggerOrEqualValue(start) &
              tbl.startTime.isSmallerThanValue(end),
        ))
        .watch();
  }
}
