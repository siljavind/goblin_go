import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';

import '../../services/settings_service.dart';

class HomeViewModel with ChangeNotifier {
  //TODO: Check this constructor use
  HomeViewModel(this._dao, this._settings) {
    _listen();
  }

  final DaySummariesDao _dao;
  final SettingsService _settings;

  double progress = 0.0;
  int xp = 0;
  int streak = 0;

  late final StreamSubscription _minSub;
  late final StreamSubscription _xpSub;
  late final StreamSubscription _sumSub;

  void _listen() {
    final dateId = _dateToDateId(DateTime.now());

    _minSub = _dao.watchTotalMinutesForDay(dateId).listen((m) {
      final goal = _settings.dailyGoal;
      progress = goal == 0 ? 0 : (m / goal).clamp(0, 1); //TODO: Look into this
      notifyListeners();
    });

    //TODO Make null safe
    _xpSub = _dao.watchTotalXp().listen((x) {
      xp = x;
      notifyListeners();
    });

    //TODO Move logic to timer service? Since it should only be evaluated once per day
    _sumSub = _dao.watchByDateId(dateId).listen((s) {
      streak = s?.streak ?? 0;
      notifyListeners();
    });
  }

  //TODO Mover to helper class since this is used in multiple places
  int _dateToDateId(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  @override
  void dispose() {
    _minSub.cancel();
    _xpSub.cancel();
    _sumSub.cancel();
    super.dispose();
  }
}
