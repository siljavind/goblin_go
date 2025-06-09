import 'package:flutter/material.dart';
import 'package:goblin_go/services/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settings = SettingsService();

  int _dailyGoal = SettingsService.defaultDailyGoal;
  ThemeMode _themeMode = SettingsService.defaultThemeMode;
  String _username = SettingsService.defaultUsername;

  int get dailyGoal => _dailyGoal;
  ThemeMode get themeMode => _themeMode;
  String get username => _username;

  SettingsViewModel() {
    _loadFromService();
  }

  Future<void> _loadFromService() async {
    // No need for await unless SettingsService ever loads async per value
    _dailyGoal = _settings.dailyGoal;
    _themeMode = _settings.themeMode;
    _username = _settings.username;
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    if (goal == _dailyGoal) return;
    _dailyGoal = goal;
    notifyListeners();
    await _settings.setDailyGoal(goal);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _settings.setThemeMode(mode);
  }

  Future<void> setUsername(String name) async {
    if (name == _username) return;
    _username = name;
    notifyListeners();
    await _settings.setUsername(name);
  }
}
