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
  late AppDatabase appDatabase;
  late OutdoorSessionsDao outdoorSessionsDao;
  late DaySummariesDao daySummariesDao;

  late MockMapboxService mockMapboxService;
  late MockBackgroundService mockBackgroundService;
  late MockTimerService mockTimerService;

  late SessionTrackerService sessionTrackerService;


  setUp(() {
    appDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    outdoorSessionsDao = OutdoorSessionsDao(appDatabase);
    daySummariesDao = DaySummariesDao(appDatabase);

    mockBackgroundService = MockBackgroundService();
    mockMapboxService = MockMapboxService();
    mockTimerService = MockTimerService();

    sessionTrackerService = SessionTrackerService(
      backgroundService: mockBackgroundService,
      mapboxService: mockMapboxService,
      timerService: mockTimerService,
      sessionsDao: outdoorSessionsDao,
      summariesDao: daySummariesDao,
    );
  });

  tearDown(() async {
    reset(mockBackgroundService);
    reset(mockMapboxService);
    reset(mockTimerService);
    await appDatabase.close();
  });

  test('inserts a session when going outside then inside', () async {
    when(mockMapboxService.isPositionOutside(longitude: 1, latitude: 1)).thenAnswer((_) async => true);
    when(mockMapboxService.isPositionOutside(longitude: 2, latitude: 2)).thenAnswer((_) async => false);

    final DateTime now = DateTime.now();

    final Position firstInsidePosition = createPosition(
        latitude: 2,
        longitude: 2,
        timestamp: now
    );

    final Position firstPositionOutside = createPosition(
        latitude: 1,
        longitude: 1,
        timestamp: now.add(Duration(minutes: 1))
    );

    final Position secondPositionOutside = createPosition(
        latitude: 1,
        longitude: 1,
        timestamp: now.add(Duration(minutes: 2))
    );

    final Position secondPositionInside = createPosition(
        latitude: 2,
        longitude: 2,
        timestamp: now.add(Duration(minutes: 3))
    );
    
    await sessionTrackerService.handlePosition(firstInsidePosition);
    await sessionTrackerService.handlePosition(firstPositionOutside);
    await sessionTrackerService.handlePosition(secondPositionOutside);
    await sessionTrackerService.handlePosition(secondPositionInside);

    final sessions = await outdoorSessionsDao.getSessionsForDay(now);

    expect(sessions, hasLength(1), reason: "Should have exactly one session");

    expect(
      sessions.first.startTime.difference(firstPositionOutside.timestamp).inSeconds,
      0,
      reason: 'Session should start when going outside',
    );
    expect(
      sessions.first.endTime.difference(secondPositionInside.timestamp).inSeconds,
      0,
      reason: 'Session should end when going inside',
    );
    expect(sessions.first.duration, 2, reason: "Session should last 2 minutes");

    verify(mockMapboxService.isPositionOutside(longitude: 1, latitude: 1)).called(2);
    verify(mockMapboxService.isPositionOutside(longitude: 2, latitude: 2)).called(2);
  });

}

Position createPosition({
  required double latitude,
  required double longitude,
  required DateTime timestamp,
}) {
  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: timestamp,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
}
