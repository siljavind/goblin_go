import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';

class LocationViewModel extends ChangeNotifier {
  LocationDto? _current;
  String? _error;

  LocationDto? get current => _current;
  String? get error => _error;

  void onLocationData(dynamic data) {
    if (data is LocationDto) {
      _current = data;
      _error = null;
      notifyListeners();
    }
  }

  void onError(dynamic error) {
    _error = error.toString();
    notifyListeners();
  }
}
