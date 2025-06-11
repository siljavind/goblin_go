import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  /// If you pass a title, it’s rendered above [child].
  final String? title;
  final Widget child;
  final String? bottomText;

  /// How much inner padding around [child]
  final EdgeInsetsGeometry padding;

  /// Overrides the default card color (uses surfaceVariant).
  final Color? color;

  const PaddedCard({
    super.key,
    this.title,
    required this.child,
    this.bottomText,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: color ?? cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (title != null) ...[
              Text(title!, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
            ],
            child,
            if (bottomText != null) ...[
              const SizedBox(height: 12),
              Text(bottomText!, style: Theme.of(context).textTheme.titleMedium),
            ],
          ],
        ),
      ),
    );
  }
}
