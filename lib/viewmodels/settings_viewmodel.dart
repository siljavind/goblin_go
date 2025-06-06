import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _keyDailyGoal = 'daily_goal';
  static const _keyPreferredTheme = 'preferred_theme';

  int _dailyGoal = 20;
  String _preferredTheme =  ThemeMode.system.name;

  int get dailyGoal => _dailyGoal;
  String get preferredTheme => _preferredTheme;

  SettingsViewModel() {
    _loadfromPrefs();
  }

  Future<void> _loadfromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _dailyGoal = prefs.getInt(_keyDailyGoal) ?? 20;
    _preferredTheme = prefs.getString(_keyPreferredTheme) ?? ThemeMode.system.name;

    notifyListeners();
  }
}