import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

//TODO: Figure out interface and implementation for location service.
/// Abstraction layer so the rest of the app never talks to plugins directly.
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
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: _onStart,
        isForegroundMode: true,
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
    );

    //TODO: Use something other than Position?
    service.on('location_event').listen((data) {
      print('Location event received: $data');
      if (data == null) return;
      _controller.add(
        Position(
          latitude: data['lat'] as double,
          longitude: data['long'] as double,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          isMocked: false,
        ),
      );
    });
  }

  @override
  Stream<Position> positionStream() => _controller.stream;

  static void _onStart(ServiceInstance service) {
    _pushLocation(service);

    final androidSettings = AndroidSettings(
      distanceFilter: 1,
      intervalDuration: const Duration(seconds: 30),
    );

    final appleSettings = AppleSettings(
      distanceFilter: 1,
      activityType: ActivityType.fitness,
      pauseLocationUpdatesAutomatically: true,
    );

    Geolocator.getPositionStream(
      locationSettings: instance is AndroidServiceInstance
          ? androidSettings
          : appleSettings,
    ).listen((position) => _pushLocation(service, position));
  }

  static Future<void> _pushLocation(
    ServiceInstance service, [
    Position? position,
  ]) async {
    final pos = position ?? await Geolocator.getCurrentPosition();
    service.invoke('location_event', {
      'lat': pos.latitude,
      'long': pos.longitude,
    });
  }
}

// TODO: Enable background fetch capability on xcode project if I get access to a Mac
Future<bool> _onIosBackground(ServiceInstance _) async => true;
