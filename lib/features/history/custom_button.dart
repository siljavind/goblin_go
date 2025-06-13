
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class FacetedProgressButton extends StatefulWidget {
  final double progress;
  final VoidCallback onPressed;
  const FacetedProgressButton({
    Key? key,
    required this.progress,
    required this.onPressed,
  }) : super(key: key);

  @override
  _FacetedProgressButtonState createState() => _FacetedProgressButtonState();
}

class _FacetedProgressButtonState extends State<FacetedProgressButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          //color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: _pressed
              ? [
            BoxShadow(
              color: Colors.blue.shade900,
              // offset: Offset(2, 2),
              blurRadius: 8,
            )
          ]
              : [
            BoxShadow(
              color: Colors.white,
              // offset: Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.blue.shade300,
              // offset: Offset(-4, -4),
              blurRadius: 6,
            ),
          ],
        ),
        child: LiquidCircularProgressIndicator(
          value: 0.4,
          valueColor: AlwaysStoppedAnimation(Colors.blue.shade800),
          borderColor: Colors.blue.shade900,
          backgroundColor: Colors.brown.shade300,
          borderWidth: 1.0,
          direction: Axis.vertical,
          center: Icon(Icons.bathtub, size: 30),
        ),
      ),
    );
  }
}
