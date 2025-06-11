import 'dart:math' as math;

import 'package:flutter/material.dart';

class GoblinWobbleProgressBar extends StatelessWidget {
  final double progress; // 0.0–1.0

  const GoblinWobbleProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _GoblinWobblePainter(progress),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your goblin emoji or image!
              const Text('🧌', style: TextStyle(fontSize: 40)),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoblinWobblePainter extends CustomPainter {
  final double progress;
  final double strokeWidth = 24.0;
  final int waveCount = 7;
  final double waveAmplitude = 8.0;

  _GoblinWobblePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final backgroundPaint = Paint()
      ..color = Colors.purple.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      backgroundPaint,
    );

    // Wavy progress arc
    final progressPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final path = Path();
    final totalAngle = 2 * math.pi * progress;
    for (double t = 0; t <= totalAngle; t += 0.01) {
      final wave = math.sin(waveCount * t) * waveAmplitude;
      final x = center.dx + (radius + wave) * math.cos(t - math.pi / 2);
      final y = center.dy + (radius + wave) * math.sin(t - math.pi / 2);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(_GoblinWobblePainter oldDelegate) => oldDelegate.progress != progress;
}
