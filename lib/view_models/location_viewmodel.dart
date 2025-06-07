import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/background_location_service.dart';

class LocationViewModel extends ChangeNotifier {
  LocationViewModel(this._location);

  final LocationService _location;

  Position? _latest;
  Position? get latest => _latest;

  void init() {
    _location.positionStream().listen((position) {
      _latest = position;
      notifyListeners();
    });
  }

  // LocationViewModel(this._location) {
  //   _location.positions().listen((position) {
  //     _latest = position;
  //     notifyListeners();
  //   });
  // }
}
