import 'dart:async';

import 'package:drift/drift.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';
import 'package:goblin_go/data/local/outdoor_sessions_dao.dart';
import 'package:goblin_go/services/location_service.dart';

import '../data/local/app_database.dart';
import 'mapbox_service.dart';

class SessionTrackerService {
  final OutdoorSessionsDao sessionsDao;
  final DaySummariesDao summariesDao;
  final LocationService locationService;
  final MapboxService mapboxService;
  final double minSessionDurationMinutes;
  final double maxHumanSpeedMps;
  final double maxAllowedAccuracyMeters;

  DateTime? _sessionStart;
  StreamSubscription<Position>? _positionSubscription;
  bool _isOutside = false;

  SessionTrackerService({
    required this.sessionsDao,
    required this.summariesDao,
    required this.locationService,
    required this.mapboxService,
    this.minSessionDurationMinutes = 1,
    this.maxHumanSpeedMps =
        10, // About 36 km/h: covers sprinting, running, biking.
    this.maxAllowedAccuracyMeters = 50,
  });

  void startSession() {
    _positionSubscription = locationService.positionStream().listen(
      _handlePosition,
    );
  }

  void stopSession() {
    _positionSubscription?.cancel();
    _sessionStart = null;
    _isOutside = false;
  }

  Future<void> _handlePosition(Position pos) async {
    if (pos.accuracy > maxAllowedAccuracyMeters) return;
    if (pos.speed > maxHumanSpeedMps) return;

    final currentlyOutside = await mapboxService.isPositionOutside(
      longitude: pos.longitude,
      latitude: pos.latitude,
    );

    if (!_isOutside && currentlyOutside) {
      // Just went outside
      _sessionStart = pos.timestamp;
    } else if (_isOutside && !currentlyOutside && _sessionStart != null) {
      //Just went inside, finish session
      //TODO: End session if user goes inside or if session hits goal
      final endTime = pos.timestamp;
      final duration = endTime.difference(_sessionStart!).inMinutes;
      if (duration >= minSessionDurationMinutes) {
        sessionsDao.insertSession(
          OutdoorSessionsCompanion.insert(
            startTime: _sessionStart!,
            endTime: endTime,
            duration: duration,
          ),
        );
      }
      await _updateDaySummary(pos.timestamp);
      _sessionStart = null;
    }
    _isOutside = currentlyOutside;
  }

  Future<void> _updateDaySummary(DateTime day) async {
    final dateId = _dateToDateId(day); // YYYYMMDD format

    final sessions = await sessionsDao.getSessionsForDay(day);
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.duration);
    //TODO: Add buffs for XP calculation?
    final totalXp = totalMinutes;

    final existing = await summariesDao.getByDateId(dateId);

    int streak;
    if (existing == null) {
      streak = await _calculateStreakForDay(dateId);
    } else {
      streak = existing.streak;
    }

    await summariesDao.upsertDaySummary(
      DaySummariesCompanion(
        dateId: Value(dateId),
        totalMinutes: Value(totalMinutes),
        totalXp: Value(totalXp),
        streak: Value(streak),
      ),
    );
  }

  Future<int> _calculateStreakForDay(int dateId) async {
    DateTime date = _dateIdToDate(dateId);
    DateTime previousDate = date.subtract(Duration(days: 1));
    int previousDateId = _dateToDateId(previousDate);

    final previousSummary = await summariesDao.getByDateId(previousDateId);

    if (previousSummary != null && previousSummary.totalMinutes > 0) {
      // Previous day had activity, continue streak
      return previousSummary.streak + 1;
    } else {
      // No activity yesterday (or first ever session)
      return 0;
    }
  }

  int _dateToDateId(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;

  DateTime _dateIdToDate(int dateId) {
    final year = dateId ~/ 10000;
    final month = (dateId % 10000) ~/ 100;
    final day = dateId % 100;
    return DateTime(year, month, day);
  }
}
