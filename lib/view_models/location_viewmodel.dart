import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/background_location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService;

  LocationViewModel(this._locationService) {
    _locationService.positionStream().listen((position) {
      _latest = position;
      notifyListeners();
    });
  }

  Position? _latest;
  Position? get latest => _latest;
}
