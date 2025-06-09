// lib/features/onboarding/onboarding_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'onboarding_state.dart';

/// ViewModel for managing onboarding location permissions.
///
/// This class handles the logic for checking, requesting, and updating
/// location permissions during the onboarding process. It uses the
/// [PermissionHandler] package to interact with the device's permission system.
class OnboardingViewModel extends ChangeNotifier with WidgetsBindingObserver {
  OnboardingState _state = OnboardingState.awaitingInUse;

  /// Getter for the current onboarding permission state.
  OnboardingState get state => _state;

  /// Initializes and checks the current permission state.
  OnboardingViewModel() {
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
  }

  /// Checks the current location permission status and updates state.
  Future<void> checkPermission() async {
    try {
      final inUse = await Permission.locationWhenInUse.status;
      final always = await Permission.locationAlways.status;

      if (always.isGranted) {
        _setState(OnboardingState.granted);
      } else if (inUse.isGranted) {
        _setState(OnboardingState.awaitingAlways);
      } else if (inUse.isPermanentlyDenied || always.isPermanentlyDenied) {
        _setState(OnboardingState.error);
      } else {
        _setState(OnboardingState.awaitingInUse);
      }
    } catch (_) {
      _setState(OnboardingState.error);
    }
  }

  /// Requests "While In Use" location permission and re-checks status.
  Future<void> requestInUse() async {
    await Permission.locationWhenInUse.request();
    await checkPermission();
  }

  /// Requests "Always" location permission and re-checks status.
  Future<void> requestAlways() async {
    await Permission.locationAlways.request();
    await checkPermission();
  }

  /// Opens the app settings for the user to manually change permissions.
  Future<void> openSettings() async => await openAppSettings();

  /// Sets the onboarding state and notifies listeners if the state changes.
  ///
  /// This method ensures that listeners are only notified when the state
  /// actually changes, preventing unnecessary updates.
  void _setState(OnboardingState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Called when the app lifecycle state changes (e.g., resumed from background)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPermission();
    }
  }

  /// Remove the observer when the ViewModel is disposed.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
