import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  /// If you pass a title, it’s rendered above [child].
  final String? title;
  final bool? bigTitle;
  final Widget child;
  final String? bottomText;

  /// How much inner padding around [child]
  final EdgeInsetsGeometry padding;

  /// Overrides the default card color (uses surfaceVariant).
  final Color? color;

  const PaddedCard({
    super.key,
    this.title,
    this.bigTitle = false,
    required this.child,
    this.bottomText,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titleSize = bigTitle!
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.titleMedium;

    return Card(
      color: color ?? cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title != null) ...[
              Text(title!, style: titleSize),
              Divider(),
              const SizedBox(height: 12),
            ],
            child,
            if (bottomText != null) ...[
              const SizedBox(height: 12),
              Divider(),
              Text(
                bottomText!,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
