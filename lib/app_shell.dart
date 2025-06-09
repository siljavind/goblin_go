// lib/app_shell.dart
import 'package:flutter/material.dart';
import 'package:goblin_go/services/background_service.dart';
import 'package:goblin_go/services/session_tracker_service.dart';
import 'package:provider/provider.dart';

import 'features/home/bottom_navigation.dart';
import 'features/onboarding/onboarding_dialog.dart';
import 'features/onboarding/onboarding_state.dart';
import 'features/onboarding/onboarding_viewmodel.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

//TODO Refactor when all MVP components are done
class _AppShellState extends State<AppShell> {
  bool _dialogShown = false;

  //TODO : Refactor to use a more robust state management solution
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final onboarding = Provider.of<OnboardingViewModel>(context);
    // Show dialog if permission not granted & not already showing
    if (!_dialogShown &&
        onboarding.state != OnboardingState.granted &&
        onboarding.state != OnboardingState.error) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => OnboardingDialog(onCompleted: _onPermissionGranted),
        ).then((_) => _dialogShown = false);
      });
    }
  }

  Future<void> _onPermissionGranted() async {
    final bg = context.read<BackgroundService>();
    final tracker = context.read<SessionTrackerService>();

    await bg.init();
    tracker.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = Provider.of<OnboardingViewModel>(context);

    if (onboarding.state != OnboardingState.granted && onboarding.state != OnboardingState.error) {
      // Show loading while waiting for permission flow to finish
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ); //TODO: Replace with placeholder of actual app
    }

    return const BottomNavigation();
  }
}
