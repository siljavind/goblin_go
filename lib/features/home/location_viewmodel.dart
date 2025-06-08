import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/location_service.dart';
import '../../services/mapbox_service.dart';

class LocationViewModel extends ChangeNotifier {
  LocationViewModel(this._locationService, this._mapboxService) {
    _locationService.positionStream().listen((position) async {
      _latest = position;
      notifyListeners();

      _isInside = null;
      notifyListeners();
      try {
        final isInside = await _mapboxService.isInBuilding(
          longitude: position.longitude,
          latitude: position.latitude,
        );
        _isInside = isInside;
      } catch (e) {
        _isInside = null; // API error
      }
      notifyListeners();
    });
  }

  final LocationService _locationService;
  final MapboxService _mapboxService;

  Position? _latest;
  Position? get latest => _latest;

  bool? _isInside;
  bool? get isInside => _isInside;
}
