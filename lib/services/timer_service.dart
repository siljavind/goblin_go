import 'dart:async';
import 'dart:ui';

class TimerService {
  TimerService();

  Timer? _timer;

  //TODO: Change to threading
  void startMidnightTimer({required VoidCallback onMidnight}) {
    _timer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);
    _timer = Timer(timeUntilMidnight, onMidnight);
  }

  void cancel() => _timer?.cancel();
}
