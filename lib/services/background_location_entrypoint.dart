import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

final androidSettings = AndroidSettings(
  distanceFilter: 0,
  intervalDuration: const Duration(seconds: 60),
);

final appleSettings = AppleSettings(
  distanceFilter: 1,
  activityType: ActivityType.fitness,
  pauseLocationUpdatesAutomatically: true,
);

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  final sub =
      Geolocator.getPositionStream(
        locationSettings: service is AndroidServiceInstance ? androidSettings : appleSettings,
      ).listen((pos) {
        service.invoke('tracking_event', {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
          'timestamp': pos.timestamp.millisecondsSinceEpoch,
          'accuracy': pos.accuracy,
          'altitude': pos.altitude,
          'heading': pos.heading,
          'speed': pos.speed,
          'speedAccuracy': pos.speedAccuracy,
          'altitudeAccuracy': pos.altitudeAccuracy,
          'headingAccuracy': pos.headingAccuracy,
        });
      });

  service.on('pause_tracking').listen((_) => sub.pause());
  service.on('resume_tracking').listen((_) => sub.resume());
}
