// lib/features/onboarding/widgets/onboarding_content.dart
import 'package:flutter/material.dart';
import 'package:goblin_go/features/onboarding/widgets/onboarding_step.dart';
import 'package:provider/provider.dart';

import '../onboarding_state.dart';
import '../onboarding_viewmodel.dart';

/// A widget that displays onboarding content based on the current state.
///
/// This widget dynamically builds different onboarding steps depending on the
/// [OnboardingState] provided by the [OnboardingViewModel]. It handles the
/// permission flow for location access during onboarding.
class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    switch (viewModel.state) {
      case OnboardingState.awaitingInUse:
        return OnboardingStep(
          icon: Icons.nature_people,
          title: "Adventure awaits!",
          description: "Let me track your location while you use the app.",
          buttonLabel: "Allow tracking while in use",
          onButtonPressed: viewModel.requestInUse,
        );

      case OnboardingState.awaitingAlways:
        return OnboardingStep(
          icon: Icons.directions_walk,
          title: "Give me superpowers!",
          description: "I need \"Always\" location access to count all your outdoor quests.",
          buttonLabel: "Allow access all the time",
          onButtonPressed: viewModel.requestAlways,
        );

      case OnboardingState.error:
        return OnboardingStep(
          icon: Icons.lock,
          title: "Permission denied",
          description: "Location permission denied. Please \"Allow all the time\" in settings.",
          buttonLabel: "Open Settings",
          onButtonPressed: viewModel.openSettings,
          error: true,
        );

      case OnboardingState.granted:
      case OnboardingState.loading:
        return const SizedBox.shrink();
    }
  }
}
