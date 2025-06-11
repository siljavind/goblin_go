import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/data/local/app_database.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';
import 'package:goblin_go/data/local/outdoor_sessions_dao.dart';
import 'package:goblin_go/services/background_service.dart';
import 'package:goblin_go/services/mapbox_service.dart';
import 'package:goblin_go/services/session_tracker_service.dart';
import 'package:goblin_go/services/timer_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_tracker_test.mocks.dart';

@GenerateMocks([MapboxService, BackgroundService, TimerService])
void main() {
  late AppDatabase db;
  late OutdoorSessionsDao sessionsDao;
  late DaySummariesDao summariesDao;

  late MockBackgroundService mockBackground;
  late MockMapboxService mockMapbox;
  late MockTimerService mockTimer;

  late SessionTrackerService trackerService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    sessionsDao = OutdoorSessionsDao(db);
    summariesDao = DaySummariesDao(db);

    mockBackground = MockBackgroundService();
    mockMapbox = MockMapboxService();
    mockTimer = MockTimerService();

    trackerService = SessionTrackerService(
      backgroundService: mockBackground,
      mapboxService: mockMapbox,
      timerService: mockTimer,
      sessionsDao: sessionsDao,
      summariesDao: summariesDao,
    );
  });

  tearDown(() async => await db.close());

  test('Records exactly one session for a single outside->inside event', () async {
    // Arrange — map outside (1,1), inside (2,2)
    when(mockMapbox.isPositionOutside(longitude: 1, latitude: 1)).thenAnswer((_) async => true);
    when(mockMapbox.isPositionOutside(longitude: 2, latitude: 2)).thenAnswer((_) async => false);

    final now = DateTime.now();

    final firstPositionInside = makePos(lat: 2, long: 2, ts: now);
    final firstPositionOutside = makePos(lat: 1, long: 1, ts: now.add(Duration(minutes: 1)));
    final secondPositionOutside = makePos(lat: 1, long: 1, ts: now.add(Duration(minutes: 2)));
    final secondPositionInside = makePos(lat: 2, long: 2, ts: now.add(Duration(minutes: 3)));

    // Act — simulate sequence
    await trackerService.handlePosition(firstPositionInside);
    await trackerService.handlePosition(firstPositionOutside);
    await trackerService.handlePosition(secondPositionOutside);
    await trackerService.handlePosition(secondPositionInside);

    // Assert — only one session in DB
    final sessions = await sessionsDao.getSessionsForDay(now);
    expect(sessions, hasLength(1), reason: "Should have exactly one session");

    final session = sessions.first;
    expect(
      truncateToSeconds(session.startTime),
      truncateToSeconds(firstPositionOutside.timestamp),
      reason: 'Session should start when going outside',
    );

    expect(
      truncateToSeconds(session.endTime),
      truncateToSeconds(secondPositionInside.timestamp),
      reason: 'Session should end when going inside',
    );

    expect(sessions.first.duration, 2, reason: "Session should last 2 minutes");

    verify(mockMapbox.isPositionOutside(longitude: 1, latitude: 1)).called(2);
    verify(mockMapbox.isPositionOutside(longitude: 2, latitude: 2)).called(2);
  });
}

/// Helper function to create a Position object with required fields
Position makePos({required double lat, required double long, required DateTime ts}) => Position(
  latitude: lat,
  longitude: long,
  timestamp: ts,
  accuracy: 0,
  altitude: 0,
  heading: 0,
  speed: 0,
  speedAccuracy: 0,
  altitudeAccuracy: 0,
  headingAccuracy: 0,
);

/// Truncates a DateTime to the second, removing any microseconds.
DateTime truncateToSeconds(DateTime dt) =>
    DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
