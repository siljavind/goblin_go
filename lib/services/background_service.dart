import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

import 'background_location_entrypoint.dart' as loc;

class BackgroundService {
  BackgroundService();

  final _controller = StreamController<Position>.broadcast();
  Stream<Position> positionStream() => _controller.stream;

  late final FlutterBackgroundService _service;

  Future<void> init() async {
    _service = FlutterBackgroundService();

    await _service.configure(
      iosConfiguration: IosConfiguration(onForeground: loc.onStart),
      androidConfiguration: AndroidConfiguration(
        onStart: loc.onStart,
        isForegroundMode: true,
        foregroundServiceTypes: [AndroidForegroundType.location],
        initialNotificationTitle: 'GoblinGo Location Service',
        initialNotificationContent: 'Tracking your location..',
      ),
    );

    _service.on('location_event').listen((event) {
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

  Future<void> pauseTracking() async => _service.invoke('pause_tracking');

  Future<void> resumeTracking() async => _service.invoke('resume_tracking');
}
