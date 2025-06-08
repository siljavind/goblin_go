// lib/features/onboarding/widgets/onboarding_step.dart
import 'package:flutter/material.dart';

/// A scaffold representing a single step in the onboarding process.
///
/// This widget displays an icon, title, description, optional "tip", and a button
/// for user interaction. It can also visually indicate an error state.
class OnboardingStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final bool error;

  const OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.error = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 60,
            color: error ? Colors.redAccent : Colors.green.shade700,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: error ? Colors.redAccent : theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: error ? Colors.redAccent : null,
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
