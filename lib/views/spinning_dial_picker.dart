// lib/views/settings/widgets/spinning_dial_picker.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// A circular “spinning wheel” that rotates under a fixed pointer at the top.
/// As the user drags around the circle, the entire dial turns, and the
/// value (0..maxValue) is determined by which tick falls under the pointer.
/// This version “remembers” the dial offset at pan start, and clamps at 0/2π
/// so it never wraps from 180→0 or 0→180.
///
/// - [size]: diameter of the widget in logical pixels.
/// - [initialValue]: starting value (0..maxValue).
/// - [maxValue]: maximum selectable value (e.g., 180).
/// - [onChanged]: callback whenever the value changes.
class SpinningDialPicker extends StatefulWidget {
  final double size;
  final int initialValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const SpinningDialPicker({
    Key? key,
    required this.size,
    required this.initialValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SpinningDialPicker> createState() => _SpinningDialPickerState();
}

class _SpinningDialPickerState extends State<SpinningDialPicker> {
  late double _rotation;          // current dial rotation (radians), clamped [0..2π]
  late int _currentValue;         // integer 0..maxValue

  // At the start of a drag, we compute this “offset”:
  //   offsetAngle = normalize(θ_touch - _rotation),
  // where θ_touch = raw screen angle at the finger, and _rotation is current rotation.
  // This offset is “which dial-angle was under the finger.”
  double _touchOffsetAngle = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize from widget.initialValue
    _currentValue = widget.initialValue.clamp(0, widget.maxValue);
    final fraction = _currentValue / widget.maxValue;
    _rotation = fraction * 2 * pi; // value 0 => rotation=0; value=max=>2π
  }

  /// Map a rotation (0..2π) into an integer 0..maxValue
  int _rotationToValue(double rotation) {
    final fraction = (rotation / (2 * pi)).clamp(0.0, 1.0);
    final rawValue = (fraction * widget.maxValue).round();
    return rawValue.clamp(0, widget.maxValue);
  }

  /// Wrap any angle into (−π..+π)
  double _normalizeAngle(double a) {
    double twoPi = 2 * pi;
    double r = a % twoPi;
    if (r > pi) r -= twoPi;
    else if (r < -pi) r += twoPi;
    return r;
  }

  /// Given a global screen position, return the raw angle (−π..+π)
  /// around the CENTER of this widget
  double _globalPosToLocalAngle(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPosition);
    final center = Offset(widget.size / 2, widget.size / 2);
    return atan2(local.dy - center.dy, local.dx - center.dx);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // 1) Compute raw screen-angle where the user first touched
        final touchAngle = _globalPosToLocalAngle(details.globalPosition);

        // 2) Compute offsetAngle = normalize(touchAngle - _rotation).
        //    This means: "when the dial is unrotated, which dial‐angle was under the finger?"
        _touchOffsetAngle = _normalizeAngle(touchAngle - _rotation);
      },
      onPanUpdate: (details) {
        // a) Raw screen-angle at this new drag position
        final newTouchAngle = _globalPosToLocalAngle(details.globalPosition);

        // b) We want to rotate the dial so that the same dial-angle
        //    (=_touchOffsetAngle) ends up under the finger. So:
        //      newRotation = newTouchAngle - offsetAngle
        double newRotation = newTouchAngle - _touchOffsetAngle;

        // c) Clamp that into [0 .. 2π]:
        newRotation = newRotation.clamp(0.0, 2 * pi);

        // d) Convert to integer 0..maxValue
        final newValue = _rotationToValue(newRotation);

        // e) Update UI & notify if actual value changed
        if (newValue != _currentValue) {
          setState(() {
            _rotation = newRotation;
            _currentValue = newValue;
          });
          widget.onChanged(newValue);
        } else {
          // Value stayed the same integer, but still update rotation so drag feels smooth
          setState(() {
            _rotation = newRotation;
          });
        }
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ① The dial itself, rotated by _rotation
            Transform.rotate(
              angle: _rotation,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _DialPainter(maxValue: widget.maxValue),
              ),
            ),

            // ② A fixed pointer at 12 o’clock (a small downward triangle)
            Positioned(
              top: 4,
              child: _PointerIndicator(),
            ),

            // ③ Numeric display at the center
            Positioned(
              child: Text(
                '$_currentValue',
                style: TextStyle(
                  fontSize: widget.size / 6,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the static dial circle & tick marks (every 10 units).
/// This painter is NOT rotated; the Transform in the widget above spins it.
class _DialPainter extends CustomPainter {
  final int maxValue;

  _DialPainter({required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1) Base circle
    final circlePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    // 2) Tick marks (every 10 units)
    final tickPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 2;
    final tickCount = (maxValue / 10).round(); // e.g. 180/10 = 18
    for (int i = 0; i < tickCount; i++) {
      final tickAngle = (i / tickCount) * 2 * pi;
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

    // 3) Inner “face”
    final innerCirclePaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.7, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) {
    return old.maxValue != maxValue;
  }
}

/// A fixed triangle pointer (12 o’clock), pointing downward to the dial.
class _PointerIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 12), // width 24, height 12
      painter: _PointerPainter(),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.shade700;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
