import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A hand-coded circular slider from 0…maxValue, with:
///  • A gradient arc representing “progress”
///  • Tick marks around the rim (every 10 units by default)
///  • A draggable thumb that follows the finger around the circle
///  • Animates smoothly when the ViewModel changes the value programmatically
///
///   size: diameter of the widget (px)
///   initialValue: 0..maxValue
///   maxValue: maximum integer (e.g. 180)
///   onChanged: callback(int) whenever the user drags
///   tickInterval: draw a tick every N units (default 10)
class CustomCircularSlider extends StatefulWidget {
  final double size;
  final int initialValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final int tickInterval;

  const CustomCircularSlider({
    Key? key,
    required this.size,
    required this.initialValue,
    required this.maxValue,
    required this.onChanged,
    this.tickInterval = 10,
  }) : super(key: key);

  @override
  State<CustomCircularSlider> createState() => _CustomCircularSliderState();
}

class _CustomCircularSliderState extends State<CustomCircularSlider>
    with SingleTickerProviderStateMixin {
  late double _angle;       // current angle, 0..2π
  late int    _value;       // current integer  0..maxValue
  late AnimationController _animController;
  late Animation<double>   _animation; // animates from old angle → new angle

  // During drag, we store the offset so that the finger “picks up” the thumb:
  double _dragStartAngle   = 0.0;
  double _dragStartValue    = 0.0;   // raw fractional 0..maxValue, not just int

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(0, widget.maxValue);
    // Map initialValue → angle: 0→0 rad (3 o'clock), but we want 0 to show at 12 o'clock,
    // so we subtract π/2. Then wrap into [0..2π).
    _angle = (_value / widget.maxValue) * 2 * math.pi - math.pi / 2;
    _angle = _normalizeAngle(_angle);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: _angle, end: _angle)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _angle = _animation.value;
          _value = (_normalizeAngle(_angle + math.pi / 2) / (2 * math.pi) *
              widget.maxValue)
              .round();
        });
      });
  }

  @override
  void didUpdateWidget(covariant CustomCircularSlider old) {
    super.didUpdateWidget(old);
    if (widget.initialValue != old.initialValue) {
      // Animate from current angle → new target angle
      final targetAngle =
          (widget.initialValue / widget.maxValue) * 2 * math.pi - math.pi / 2;
      final normalizedTarget = _normalizeAngle(targetAngle);
      _animation = Tween<double>(begin: _angle, end: normalizedTarget).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut),
      );
      _animController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Wrap any angle to [0..2π)
  double _normalizeAngle(double a) {
    double twoPi = 2 * math.pi;
    double r = a % twoPi;
    if (r < 0) r += twoPi;
    return r;
  }

  /// Given a touch at globalPos, return the angle [−π..+π] around the center
  double _getTouchAngle(Offset globalPos) {
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPos);
    final center = Offset(widget.size / 2, widget.size / 2);
    return math.atan2(local.dy - center.dy, local.dx - center.dx);
  }

  void _onPanStart(DragStartDetails details) {
    // When user first touches, figure out the fractional value under their finger:
    final touchAngle = _getTouchAngle(details.globalPosition);
    final rawValue =
        (_normalizeAngle(touchAngle + math.pi / 2) / (2 * math.pi)) *
            widget.maxValue;
    _dragStartValue = rawValue;
    _dragStartAngle = touchAngle - _angle; // offset between touch and current
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final touchAngle = _getTouchAngle(details.globalPosition);
    // Compute new angle so that (touchAngle - newAngle) == _dragStartAngle → newAngle = touchAngle - offset
    double newAngle = touchAngle - _dragStartAngle;
    // Normalize and clamp so it never wraps past 0 or 2π
    newAngle = newAngle.clamp(-math.pi / 2, 3 * math.pi / 2);
    // Map that to a raw fractional value
    final rawValue =
        (_normalizeAngle(newAngle + math.pi / 2) / (2 * math.pi)) *
            widget.maxValue;
    final int newValue = rawValue.round().clamp(0, widget.maxValue);

    setState(() {
      _angle = newAngle;
      _value = newValue;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1) Background + tick marks
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _DialBackgroundPainter(
                tickInterval: widget.tickInterval,
                maxValue: widget.maxValue,
              ),
            ),
            // 2) Progress arc (gradient) and thumb
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _ProgressArcPainter(
                angle: _angle,
                maxValue: widget.maxValue,
              ),
            ),
            // 3) Thumb (a small circle) at the end of the arc
            _Thumb(angle: _angle, radius: widget.size / 2),
            // 4) Numeric label at center
            Text(
              '$_value',
              style: TextStyle(
                fontSize: widget.size / 6,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the background circle + tick marks
class _DialBackgroundPainter extends CustomPainter {
  final int tickInterval;
  final int maxValue;

  _DialBackgroundPainter({
    required this.tickInterval,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1) Draw a light gray circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // 2) Draw tick marks every tickInterval units
    final tickPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 2;
    final tickCount = (maxValue / tickInterval).round();
    for (int i = 0; i < tickCount; i++) {
      final tickAngle = (i / tickCount) * 2 * math.pi - math.pi / 2;
      final inner = Offset(
        center.dx + (radius - 12) * math.cos(tickAngle),
        center.dy + (radius - 12) * math.sin(tickAngle),
      );
      final outer = Offset(
        center.dx + radius * math.cos(tickAngle),
        center.dy + radius * math.sin(tickAngle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }

    // 3) Draw a lighter inner circle
    final innerPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.7, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DialBackgroundPainter old) =>
      old.tickInterval != tickInterval || old.maxValue != maxValue;
}

/// Paints the gradient progress arc from 0 up to [_angle]
class _ProgressArcPainter extends CustomPainter {
  final double angle;
  final int maxValue;

  _ProgressArcPainter({
    required this.angle,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw a gradient arc from -π/2 up to (angle)
    final rect = Rect.fromCircle(center: center, radius: radius - 6);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: angle,
      colors: [Colors.green.shade400, Colors.green.shade800],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      angle < 0 ? 0 : angle, // if angle < 0, draw nothing
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressArcPainter old) => old.angle != angle;
}

/// A small draggable thumb (circle) at the end of the gradient arc
class _Thumb extends StatelessWidget {
  final double angle;
  final double radius;

  const _Thumb({required this.angle, required this.radius});

  @override
  Widget build(BuildContext context) {
    // Compute the thumb’s center position: angle runs from -π/2 to 3π/2
    final thumbX = radius + (radius - 6) * math.cos(angle);
    final thumbY = radius + (radius - 6) * math.sin(angle);

    return Positioned(
      left: thumbX - 8, // thumb diameter = 16
      top: thumbY - 8,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.shade900,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
