import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:goblin_go/data/local/day_summaries_dao.dart';

class HomeViewModel with ChangeNotifier {
  HomeViewModel(this._dao) {
    _listen();
  }

  final DaySummariesDao _dao;

  int minutes = 0;
  int xp = 0;
  int streak = 0;

  late final StreamSubscription _minutesSub;
  late final StreamSubscription _xpSub;
  late final StreamSubscription _summariesSub;

  void _listen() {
    final dateId = _dateToDateId(DateTime.now());
    _minutesSub = _dao.watchTotalMinutesForDay(dateId).listen((m) {
      minutes = m;
      notifyListeners();
    });

    _xpSub = _dao.watchTotalXp().listen((x) {
      xp = x;
      notifyListeners();
    });

    // TODO Move logic to timer service? Since it should only be evaluated once per day
    _summariesSub = _dao.watchByDateId(dateId).listen((s) {
      streak = s?.streak ?? 0;
      notifyListeners();
    });
  }

  int _dateToDateId(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  @override
  void dispose() {
    _minutesSub.cancel();
    _xpSub.cancel();
    _summariesSub.cancel();
    super.dispose();
  }
}
