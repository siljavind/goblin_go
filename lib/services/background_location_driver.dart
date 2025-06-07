import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

@pragma('vm:entry-point')
Future<void> backgroundServiceOnStart(ServiceInstance service) async {
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
