import 'package:flutter/material.dart';
import 'package:goblin_go/services/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService;

  int _dailyGoal = SettingsService.defaultDailyGoal;
  ThemeMode _themeMode = SettingsService.defaultThemeMode;
  String _username = SettingsService.defaultUsername;

  int get dailyGoal => _dailyGoal;
  ThemeMode get themeMode => _themeMode;
  String get username => _username;

  SettingsViewModel(this._settingsService) {
    _load();
  }

  Future<void> _load() async {
    print('Loading settings...');
    _dailyGoal = _settingsService.dailyGoal;
    print('Daily goal: $_dailyGoal');
    _themeMode = _settingsService.themeMode;
    print('Theme mode: $_themeMode');
    _username = _settingsService.username;
    print('Username: $_username');
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    if (goal == _dailyGoal) return;
    _dailyGoal = goal;
    notifyListeners();
    await _settingsService.setDailyGoal(goal);
    print(_dailyGoal);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _settingsService.setThemeMode(mode);
  }

  Future<void> setUsername(String name) async {
    if (name == _username) return;
    _username = name;
    notifyListeners();
    await _settingsService.setUsername(name);
  }
}
