import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/utils/constants.dart';

final androidSettings = AndroidSettings(
  accuracy: LocationAccuracy.bestForNavigation,
  distanceFilter: 0,
  intervalDuration: const Duration(seconds: 60),
);

final appleSettings = AppleSettings(
  accuracy: LocationAccuracy.bestForNavigation,
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
        service.invoke(ConstantStrings.eventName, {
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

  service.on(ConstantStrings.pauseTracking).listen((_) => sub.pause());
  service.on(ConstantStrings.resumeTracking).listen((_) => sub.resume());
}
