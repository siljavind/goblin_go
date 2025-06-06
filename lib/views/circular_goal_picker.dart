import 'dart:math';
import 'package:flutter/material.dart';

/// A circular “rotary dial” that lets the user pick an integer value
/// between 0 and [maxValue] by dragging around the circle.
///
/// - [size]: diameter of the widget in logical pixels.
/// - [initialValue]: starting value (0..maxValue).
/// - [maxValue]: maximum selectable value (e.g., 180).
/// - [onChanged]: callback whenever the value changes.
class CircularGoalPicker extends StatefulWidget {
  final double size;
  final int initialValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const CircularGoalPicker({
    Key? key,
    required this.size,
    required this.initialValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CircularGoalPicker> createState() => _CircularGoalPickerState();
}

class _CircularGoalPickerState extends State<CircularGoalPicker> {
  late double _angle;      // current angle (in radians), 0 = “top”
  late int _currentValue;  // current integer value (0..maxValue)

  @override
  void initState() {
    super.initState();
    // Convert the initialValue into an angle. We interpret 0 at top (−π/2),
    // and full circle corresponds to maxValue. Then clamp.
    _currentValue = widget.initialValue.clamp(0, widget.maxValue);

    // Map value → angle:
    // value/maxValue * 2π, but shift so 0 sits at the top, not the right.
    final fraction = _currentValue / widget.maxValue;
    _angle = (fraction * 2 * pi) - (pi / 2);
  }

  /// Convert an angle (radians) into a 0..maxValue integer.
  int _angleToValue(double angle) {
    // Normalize angle to [0, 2π). Flutter’s atan2 returns (−π, π].
    double a = angle + (pi / 2); // shift so 0 at “top”
    if (a < 0) a += 2 * pi;
    if (a >= 2 * pi) a -= 2 * pi;

    final fraction = a / (2 * pi);
    final raw = (fraction * widget.maxValue).round();
    return raw.clamp(0, widget.maxValue);
  }

  /// Convert a (global) pointer location into an angle around the circle center.
  double _positionToAngle(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPosition);
    final center = Offset(widget.size / 2, widget.size / 2);
    return atan2(local.dy - center.dy, local.dx - center.dx);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // When the user first touches, set angle and value immediately
        final newAngle = _positionToAngle(details.globalPosition);
        final newValue = _angleToValue(newAngle);
        setState(() {
          _angle = newAngle;
          _currentValue = newValue;
        });
        widget.onChanged(_currentValue);
      },
      onPanUpdate: (details) {
        // As the user drags, recalculate angle and value continuously
        final newAngle = _positionToAngle(details.globalPosition);
        final newValue = _angleToValue(newAngle);
        setState(() {
          _angle = newAngle;
          _currentValue = newValue;
        });
        widget.onChanged(_currentValue);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _DialPainter(
            angle: _angle,
            maxValue: widget.maxValue,
            currentValue: _currentValue,
          ),
        ),
      ),
    );
  }
}

/// Painter for the rotary dial:
/// - Draws a grey circular background.
/// - Draws tick marks around (every 10 units).
/// - Draws a colored needle/indicator at the current [angle].
/// - Draws the [_currentValue] as text in the center.
class _DialPainter extends CustomPainter {
  final double angle;
  final int maxValue;
  final int currentValue;

  _DialPainter({
    required this.angle,
    required this.maxValue,
    required this.currentValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1) Draw the base circle
    final circlePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    // 2) Draw tick marks (every 10 units)
    final tickPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2;
    final tickCount = ((maxValue / 10).ceil());
    for (int i = 0; i < tickCount; i++) {
      final tickAngle = (i / tickCount) * 2 * pi - (pi / 2);
      final inner = Offset(
        center.dx + (radius - 12) * cos(tickAngle),
        center.dy + (radius - 12) * sin(tickAngle),
      );
      final outer = Offset(
        center.dx + radius * cos(tickAngle),
        center.dy + radius * sin(tickAngle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }

    // 3) Draw the “needle” or indicator line
    final needlePaint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final needleLength = radius - 20;
    final needleEnd = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // 4) Draw the current value text at center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$currentValue',
        style: TextStyle(
          fontSize: radius / 2.5,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = center -
        Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) {
    return old.angle != angle || old.currentValue != currentValue;
  }
}

