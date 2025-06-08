import 'package:flutter/material.dart';

/// A simple Card wrapper with consistent margin, elevation, and padding.
class SettingCard extends StatelessWidget {
  final Widget child;
  const SettingCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      ),
    );
  }
}
