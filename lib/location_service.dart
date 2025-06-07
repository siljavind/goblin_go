// import 'dart:async';
//
// import 'package:geolocator/geolocator.dart';
//
// class LocationService {
//   Stream<Position>? _positionStream;
//
//   Stream<Position> getPositionStream() {
//     _positionStream ??= _initStream();
//     return _positionStream!;
//   }
//
//   Stream<Position> _initStream() async* {
//     LocationPermission permission = await Geolocator.checkPermission();
//     // TODO: Handle permission request gracefully
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.always &&
//           permission != LocationPermission.whileInUse) {
//         throw Exception('Location permission not granted');
//       }
//     }
//
//     yield* Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 5,
//       ),
//     );
//   }
// }
