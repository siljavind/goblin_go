import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';

class HomeViewModel with ChangeNotifier {
  //TODO: Check this constructor use
  HomeViewModel(this._dao) {
    _listen();
  }

  final DaySummariesDao _dao;

  int minutes = 0;
  int xp = 0;
  int streak = 0;

  late final StreamSubscription _minSub;
  late final StreamSubscription _xpSub;
  late final StreamSubscription _sumSub;

  void _listen() {
    final dateId = _dateToDateId(DateTime.now());
    //TODO: Make sure the progress updates when the daily goal changes
    _minSub = _dao.watchTotalMinutesForDay(dateId).listen((m) {
      minutes = m;
      notifyListeners();
    });

    // TODO Make null safe
    _xpSub = _dao.watchTotalXp().listen((x) {
      xp = x;
      notifyListeners();
    });

    // TODO Move logic to timer service? Since it should only be evaluated once per day
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
