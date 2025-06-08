// lib/features/onboarding/onboarding_dialog.dart
import 'package:flutter/material.dart';
import 'package:goblin_go/features/onboarding/onboarding_viewmodel.dart';
import 'package:goblin_go/features/onboarding/widgets/onboarding_content.dart';
import 'package:provider/provider.dart';

import 'onboarding_state.dart';

/// A dialog widget that manages the onboarding permission flow.
///
/// This widget displays an alert dialog with onboarding content and listens
/// for changes in the onboarding state. When permissions are granted, it
/// triggers the [onCompleted] callback and closes the dialog.
class OnboardingDialog extends StatefulWidget {
  /// Callback triggered when onboarding is completed (permissions granted).
  final VoidCallback onCompleted;
  const OnboardingDialog({required this.onCompleted, super.key});

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

/// State class for [OnboardingDialog].
///
/// Handles the lifecycle of the dialog, including listening to changes
/// in the [OnboardingViewModel] and responding to state updates.
class _OnboardingDialogState extends State<OnboardingDialog> {
  /// Reference to the current [OnboardingViewModel].
  OnboardingViewModel? viewModel;

  /// Listener callback for changes in the [OnboardingViewModel].
  late VoidCallback listener;

  @override
  Widget build(BuildContext context) {
    // Builds the alert dialog with onboarding content.
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: const OnboardingContent(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieves the current [OnboardingViewModel] from the provider.
    final currentViewModel = Provider.of<OnboardingViewModel>(context);

    // Updates the listener if the view model changes.
    if (viewModel != currentViewModel) {
      viewModel?.removeListener(listener);
      viewModel = currentViewModel;
      listener = () {
        // If permissions are granted, trigger the callback and close the dialog.
        if (viewModel!.state == OnboardingState.granted) {
          widget.onCompleted();
          Navigator.of(context).pop();
        }
      };
      // Adds the listener to the new view model.
      viewModel!.addListener(listener);
    }
  }

  @override
  void dispose() {
    viewModel?.removeListener(listener);
    super.dispose();
  }
}
