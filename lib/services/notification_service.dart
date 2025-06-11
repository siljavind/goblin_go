import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';
import 'package:goblin_go/services/settings_service.dart';

class NotificationService {
  final SettingsService _settings;
  final DaySummariesDao _summariesDao;
  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();
  final _rng = Random();
  Timer? _timer;

  static const notificationChannelId = 'goblin_goal_reminder';

  NotificationService(this._settings, this._summariesDao);

  //TODO: Review when I have access to an Android 13+ device and an iOS device
  Future<void> init() async {
    await _fln.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_goblin'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // Android 13+: prompt for POST_NOTIFICATIONS
    await _fln
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS: prompt for permissions
    await _fln
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    const channel = AndroidNotificationChannel(
      notificationChannelId,
      'Goal Reminders',
      importance: Importance.high,
      description: 'Remind if goal not met',
    );

    await _fln
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Schedule the first notification check
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(hours: 2), (_) => _check());
  }

  Future<void> _check() async {
    final goal = _settings.dailyGoal;
    final done = await _summariesDao.getTotalMinutesForDay(DateTime.now());
    if (done >= goal) return;

    final now = DateTime.now();
    if (now.hour < 10 || now.hour >= 24) return;

    final user = _settings.username.isNotEmpty ? _settings.username : "Goblin";
    final pct = done / goal;

    List<String> pool;
    if (pct < .25) {
      pool = [
        "$user, lazy goblin—only $done/$goal minutes. Chop-chop!",
        "Hey $user, your goblin slippers won’t move themselves - $done of $goal minutes today.",
        "$user, wake up! You've only done $done of $goal minutes.",
      ];
    } else if (pct < .75) {
      pool = [
        "$user, half-hearted goblin: $done/$goal minutes done. Push harder!",
        "Only $done of $goal minutes, $user - do goblins nap all day?",
        "$user, midway through and you’re stalling: $done/$goal minutes done.",
      ];
    } else {
      pool = [
        "$user, goblin almost there: $done/$goal. Claim your loot!",
        "Last stretch, $user: $done/$goal minutes. Don’t fumble the treasure!",
        "So close, $user! $done of $goal minutes - one last push!",
      ];
    }

    final msg = pool[_rng.nextInt(pool.length)];
    await _fln.show(
      1001,
      "$user, your Goblin Go reminder",
      msg,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'Goal Reminders',
          icon: 'ic_stat_goblin',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void dispose() => _timer?.cancel();
}
