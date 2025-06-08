import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _keyDailyGoal = 'daily_goal';
  static const _keyThemeMode = 'theme_mode';
  static const _keyUsername = 'username';

  int _dailyGoal = 20;
  ThemeMode _themeMode = ThemeMode.system;
  String _username = '';

  int get dailyGoal => _dailyGoal;
  ThemeMode get themeMode => _themeMode;
  String get username => _username;

  SettingsViewModel() {
    _loadFromPrefs();
  }

  //TODO: Change sets into delegates or something?
  Future<void> setDailyGoal(int goal) async {
    if (goal == _dailyGoal) return;

    _dailyGoal = goal;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailyGoal, goal);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> setUsername(String name) async {
    if (name == _username) return;

    _username = name;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, name);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_keyDailyGoal)) {
      _dailyGoal = prefs.getInt(_keyDailyGoal)!;
    }

    if (prefs.containsKey(_keyThemeMode)) {
      final storedIndex = prefs.getInt(_keyThemeMode)!;
      if (storedIndex >= 0 && storedIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[storedIndex];
      }
    }

    if (prefs.containsKey(_keyUsername)) {
      _username = prefs.getString(_keyUsername)!;
    }

    notifyListeners();
  }
}
