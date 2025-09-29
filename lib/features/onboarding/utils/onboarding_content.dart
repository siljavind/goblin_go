import 'package:flutter/material.dart';
import 'package:goblin_go/features/onboarding/utils/onboarding_widget.dart';
import 'package:provider/provider.dart';

import '../onboarding_viewmodel.dart';
import 'onboarding_state.dart';

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
        return OnboardingWidget(
          icon: Icons.nature_people,
          title: "Location Access Required!",
          description: "To enable core app features, please allow this app to access your device's location while in use",
          buttonLabel: "Allow while in use",
          onButtonPressed: viewModel.requestInUse,
        );

      case OnboardingState.awaitingAlways:
        return OnboardingWidget(
          icon: Icons.directions_walk,
          title: "Background Location Access",
          description: "For optimal functionality, including tracking outdoor quests even when the app is not active, please grant \"Allow all the time\" location access.",
          buttonLabel: "Allow all the time",
          onButtonPressed: viewModel.requestAlways,
        );

      case OnboardingState.error:
        return OnboardingWidget(
          icon: Icons.lock,
          title: "Permission denied",
          description: "Location permission has been denied. To use this app's location features, please grant \"Allow all the time\" permission in your device settings.",
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
