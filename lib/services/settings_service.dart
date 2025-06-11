// lib/services/settings_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Preference keys
  static const String _keyDailyGoal = 'daily_goal';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyUsername = 'username';

  static const int defaultDailyGoal = 20;
  static const ThemeMode defaultThemeMode = ThemeMode.system;
  static const String defaultUsername = '';

  SharedPreferences? _prefs;

  // Ensure prefs are loaded before using (call once in app startup)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  int get dailyGoal => _prefs?.getInt(_keyDailyGoal) ?? defaultDailyGoal;

  //TODO: Reset progress for the day if user changes daily goal
  Future<void> setDailyGoal(int value) async => await _prefs?.setInt(_keyDailyGoal, value);

  ThemeMode get themeMode {
    final index = _prefs?.getInt(_keyThemeMode);
    return index != null ? ThemeMode.values[index] : defaultThemeMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async =>
      await _prefs?.setInt(_keyThemeMode, mode.index);

  // --- Username ---
  String get username => _prefs?.getString(_keyUsername) ?? defaultUsername;

  Future<void> setUsername(String value) async => await _prefs?.setString(_keyUsername, value);
}
