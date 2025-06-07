import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _svc;
  Position? _current;
  String? _error;
  StreamSubscription<Position>? _sub;

  LocationViewModel(this._svc) {
    _startListening();
  }

  Position? get currentPosition => _current;
  String? get error => _error;

  void _startListening() {
    _sub = _svc.getPositionStream().listen(
      (pos) {
        _current = pos;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _error = err.toString();
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
