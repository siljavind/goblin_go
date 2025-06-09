import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goblin_go/data/local/app_database.dart';
import 'package:goblin_go/data/local/outdoor_sessions_dao.dart';

void main() {
  late AppDatabase database;
  late OutdoorSessionsDao sessionsDao;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    sessionsDao = OutdoorSessionsDao(database);
  });
  tearDown(() async {
    await database.close();
  });

  group('OutdoorSessions table', () {
    test('Inserts a new session successfully', () async {
      final now = DateTime.now();
      await sessionsDao.insertSession(
        OutdoorSessionsCompanion.insert(
          startTime: now,
          endTime: now.add(Duration(hours: 1)),
          duration: 60,
        ),
      );

      final sessions = await sessionsDao.getSessionsForDay(now);
      expect(sessions, isNotEmpty, reason: "Should have one session");
    });

    test('Get sessions for a specific day', () async {
      final now = DateTime.now();
      await sessionsDao.insertSession(
        OutdoorSessionsCompanion.insert(
          startTime: now,
          endTime: now.add(Duration(hours: 1)),
          duration: 60,
        ),
      );

      await sessionsDao.insertSession(
        OutdoorSessionsCompanion.insert(
          startTime: now.subtract(Duration(days: 1)),
          endTime: now.subtract(Duration(days: 1)).add(Duration(hours: 1)),
          duration: 60,
        ),
      );

      final sessions = await sessionsDao.getSessionsForDay(now);
      expect(
        sessions,
        hasLength(1),
        reason: "Should only retrieve the session for the specific day",
      );
      expect(
        sessions.first.startTime.difference(now).inSeconds,
        0,
        reason: 'Should match to the second (ignore microseconds)',
      );
    });
  });
}
