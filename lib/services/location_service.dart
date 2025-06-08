import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

//TODO: Figure out interface and implementation for location service.
abstract interface class LocationService {
  Stream<Position> positionStream();
}

//TODO: Implement single source of truth for location service
//TODO: Is broadcast stream necessary here?
class BackgroundLocationService implements LocationService {
  BackgroundLocationService._();
  static final BackgroundLocationService instance =
      BackgroundLocationService._();

  final _controller = StreamController<Position>.broadcast();

  Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(onForeground: onStart),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        foregroundServiceTypes: [AndroidForegroundType.location],
        initialNotificationTitle: 'GoblinGo Location Service',
        initialNotificationContent: 'Tracking your location..',
      ),
    );

    service.on('location_event').listen((event) {
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

  @override
  Stream<Position> positionStream() => _controller.stream;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  Geolocator.getPositionStream(
    locationSettings: service is AndroidServiceInstance
        ? androidSettings
        : appleSettings,
  ).listen((pos) {
    service.invoke('location_event', {
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'timestamp': pos.timestamp?.millisecondsSinceEpoch,
      'accuracy': pos.accuracy,
      'altitude': pos.altitude,
      'heading': pos.heading,
      'speed': pos.speed,
      'speedAccuracy': pos.speedAccuracy,
      'altitudeAccuracy': pos.altitudeAccuracy,
      'headingAccuracy': pos.headingAccuracy,
    });
  });
}

final androidSettings = AndroidSettings(
  distanceFilter: 0,
  intervalDuration: const Duration(seconds: 60),
);

final appleSettings = AppleSettings(
  distanceFilter: 1,
  activityType: ActivityType.fitness,
  pauseLocationUpdatesAutomatically: true,
);
