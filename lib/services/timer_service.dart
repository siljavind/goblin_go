import 'dart:async';
import 'dart:ui';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  Timer? _timer;

  void startMidnightTimer({required VoidCallback onMidnight}) {
    _timer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);
    _timer = Timer(timeUntilMidnight, onMidnight);
  }

  void cancel() => _timer?.cancel();
}
