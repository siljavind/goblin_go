import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/utils/constants.dart';

import 'background_geolocator_entrypoint.dart' as loc;

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final _controller = StreamController<Position>.broadcast();
  Stream<Position> positionStream() => _controller.stream;

  late final FlutterBackgroundService _service;
  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  static const notificationChannelId = 'goblin_background';
  static const notificationId = 888;

  Future<void> init() async {
    const channel = AndroidNotificationChannel(
      notificationChannelId,
      'GOBLIN BACKGROUND SERVICE',
      description: 'Keep app alive in background',
      importance: Importance.low,
    );

    await _fln
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _service = FlutterBackgroundService();

    await _service.configure(
      iosConfiguration: IosConfiguration(onForeground: loc.onStart),
      androidConfiguration: AndroidConfiguration(
        notificationChannelId: notificationChannelId,
        onStart: loc.onStart,
        isForegroundMode: true,
        foregroundServiceTypes: [AndroidForegroundType.location],
        foregroundServiceNotificationId: notificationId,
      ),
    );

    await _fln.show(
      notificationId,
      "GoblinGo tracking",
      "Tracking your location..",
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'GOBLIN BACKGROUND SERVICE',
          icon: 'ic_stat_goblin',
          ongoing: true,
        ),
      ),
    );

    _startListening();
  }

  void _startListening() {
    _service.on(ConstantStrings.eventName).listen((event) {
      if (event == null) return;
      _controller.add(
        Position(
          latitude: (event['latitude'] ?? 0).toDouble(),
          longitude: (event['longitude'] ?? 0).toDouble(),
          timestamp: DateTime.fromMillisecondsSinceEpoch(event['timestamp']),
          accuracy: (event['accuracy'] ?? 0).toDouble(),
          altitude: (event['altitude'] ?? 0).toDouble(),
          heading: (event['heading'] ?? 0).toDouble(),
          speed: (event['speed'] ?? 0).toDouble(),
          speedAccuracy: (event['speedAccuracy'] ?? 0).toDouble(),
          altitudeAccuracy: (event['altitudeAccuracy'] ?? 0).toDouble(),
          headingAccuracy: (event['headingAccuracy'] ?? 0).toDouble(),
        ),
      );
    });
  }

  Future<void> pauseTracking() async => _service.invoke(ConstantStrings.pauseTracking);

  Future<void> resumeTracking() async => _service.invoke(ConstantStrings.resumeTracking);
}
