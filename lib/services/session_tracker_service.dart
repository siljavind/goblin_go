import 'dart:async';

import 'package:drift/drift.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';
import 'package:goblin_go/data/local/outdoor_sessions_dao.dart';
import 'package:goblin_go/services/background_service.dart';
import 'package:goblin_go/services/settings_service.dart';
import 'package:goblin_go/services/timer_service.dart';

import '../data/local/app_database.dart';
import 'mapbox_service.dart';

class SessionTrackerService {
  final BackgroundService backgroundService;
  final MapboxService mapboxService;
  final TimerService timerService;
  final OutdoorSessionsDao sessionsDao;
  final DaySummariesDao summariesDao;

  StreamSubscription<Position>? _positionSubscription;
  DateTime? _sessionStart;
  bool _isOutside = false;
  bool _wasOutside = false;
  int _speedyGonzalesStrike = 0;
  Position? _speedyPosition;

  SessionTrackerService({
    required this.backgroundService,
    required this.mapboxService,
    required this.timerService,
    required this.sessionsDao,
    required this.summariesDao,
  });

  void startTracking() =>
    _positionSubscription = backgroundService.positionStream().listen(_handlePosition);


  Future<void> _handlePosition(Position pos) async {
    // Handle cases where the user is moving too fast
    if (pos.speed >= 7) {
      if (++_speedyGonzalesStrike == 1) _speedyPosition = pos;
      if (_speedyGonzalesStrike >= 3) {
        await _endSessionIfActive();
        return;
      }
    } else {
      _speedyGonzalesStrike = 0;
    }

    _isOutside = await mapboxService.isPositionOutside(
      longitude: pos.longitude,
      latitude: pos.latitude,
    );

    // Transition: inside -> outside
    if (!_wasOutside && _isOutside) {
      _sessionStart = pos.timestamp;
    }
    // Transition: outside -> inside
    else if (_wasOutside && !_isOutside && _sessionStart != null) {
      await _saveSession(_sessionStart!, pos.timestamp);
      _sessionStart = null;
    }
    // While outside: check if daily goal is reached
    else if (_isOutside && _sessionStart != null) {
      _checkDailyGoal(pos);
    }

    _wasOutside = _isOutside;
  }

  Future<void> _checkDailyGoal(Position pos) async {
    final duration = pos.timestamp.difference(_sessionStart!).inMinutes;
    final totalMinutes = await _getTotalSessionTimeMinutes(pos.timestamp) + duration;

    if (totalMinutes >= SettingsService().dailyGoal) {
      await _saveSession(_sessionStart!, pos.timestamp);
      _sessionStart = null;
      pauseTracking();
    }
  }

  Future<void> _endSessionIfActive() async {
    if (_sessionStart != null) {
      await _saveSession(_sessionStart!, _speedyPosition!.timestamp);
      _sessionStart = null;
    }
    _wasOutside = false;
    _isOutside = false;
    _speedyGonzalesStrike = 0;
  }

  Future<void> _saveSession(DateTime start, DateTime end) async {
    final duration = end.difference(start).inMinutes;
    if (duration < 1) {
      return; // Ignore sessions shorter than 1 minute
    }
    await sessionsDao.insertSession(
      OutdoorSessionsCompanion.insert(startTime: start, endTime: end, duration: duration),
    );
    await _updateDaySummary(start);
  }

  //TODO: Add buffs for XP calculation
  Future<void> _updateDaySummary(DateTime start) async {
    final dateId = _dateToDateId(start);
    final existingSummary = await summariesDao.getByDateId(dateId);
    final streak = existingSummary?.streak ?? await _calculateStreakForDay(start);

    final totalMinutesForDay = await _getTotalSessionTimeMinutes(start);
    final totalXpForDay = (totalMinutesForDay + (streak * 1.5)).round();

    await summariesDao.upsertDaySummary(
      DaySummariesCompanion(
        dateId: Value(dateId),
        totalMinutes: Value(totalMinutesForDay),
        totalXp: Value(totalXpForDay),
        streak: Value(streak),
      ),
    );
  }

  Future<int> _calculateStreakForDay(DateTime date) async {
    DateTime previousDate = date.subtract(Duration(days: 1));
    int previousDateId = _dateToDateId(previousDate);

    final previousSummary = await summariesDao.getByDateId(previousDateId);

    if (previousSummary != null && previousSummary.totalMinutes >= SettingsService().dailyGoal) {
      return previousSummary.streak + 1;
    } else {
      return 0;
    }
  }

  Future<int> _getTotalSessionTimeMinutes(DateTime timestamp) async {
    final sessions = await sessionsDao.getSessionsForDay(timestamp);
    return sessions.fold<int>(0, (sum, s) => sum + s.duration);
  }

  Future<bool> hasReachedDailyGoal(Position pos) async {
    final totalMinutes = await _getTotalSessionTimeMinutes(pos.timestamp);
    return totalMinutes >= SettingsService().dailyGoal;
  }

  Future<void> pauseTracking() async {
    _positionSubscription?.pause();
    await backgroundService.pauseTracking();
    timerService.startMidnightTimer(onMidnight: () => resumeTracking());
  }

  Future<void> resumeTracking() async {
    await backgroundService.resumeTracking();
    _positionSubscription?.resume();
  }

  int _dateToDateId(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day; // YYYYMMDD format
}
