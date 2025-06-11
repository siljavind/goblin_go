import 'package:drift/drift.dart';

import 'app_database.dart';

part 'outdoor_sessions_dao.g.dart';

@DriftAccessor(tables: [OutdoorSessions])
class OutdoorSessionsDao extends DatabaseAccessor<AppDatabase> with _$OutdoorSessionsDaoMixin {
  OutdoorSessionsDao(super.db);

  Future<int> insertSession(OutdoorSessionsCompanion entry) => into(outdoorSessions).insert(entry);

  /// Gets all sessions for a given day.
  Future<List<OutdoorSession>> getSessionsForDay(DateTime date) {
    final range = _computeStartAndEnd(date);
    return (select(outdoorSessions)..where(
          (tbl) =>
              tbl.startTime.isBiggerOrEqualValue(range['start']!) &
              tbl.startTime.isSmallerThanValue(range['end']!),
        ))
        .get();
  }

  /// Watches (streams) all sessions for a given day.
  Stream<List<OutdoorSession>> watchSessionsForDay(DateTime date) {
    final range = _computeStartAndEnd(date);
    return (select(outdoorSessions)..where(
          (tbl) =>
              tbl.startTime.isBiggerOrEqualValue(range['start']!) &
              tbl.startTime.isSmallerThanValue(range['end']!),
        ))
        .watch();
  }
}

Map<String, DateTime> _computeStartAndEnd(DateTime date) {
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(const Duration(days: 1));
  return {'start': start, 'end': end};
}
