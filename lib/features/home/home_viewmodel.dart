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

  late final StreamSubscription _summarySub;

  void _listen() {
    final dateId = _dateToDateId(DateTime.now());

    _summarySub = _dao.watchByDateId(dateId).listen((summary) {
      if (summary != null) {
        minutes = summary.totalMinutes;
        xp = summary.totalXp;
        streak = summary.streak;
      }
      notifyListeners();
    });
  }

  int _dateToDateId(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  @override
  void dispose() {
    _summarySub.cancel();
    super.dispose();
  }
}
