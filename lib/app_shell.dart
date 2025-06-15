// lib/app_shell.dart
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:goblin_go/services/background/background_service.dart';
import 'package:goblin_go/services/tracking/session_tracker_service.dart';
import 'package:provider/provider.dart';

import 'data/local/app_database.dart';
import 'features/home/home_view.dart';
import 'features/onboarding/onboarding_dialog.dart';
import 'features/onboarding/onboarding_viewmodel.dart';
import 'features/onboarding/utils/onboarding_state.dart';
import 'features/settings/settings_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _dialogShown = false;
  int _selectedPageIndex = 0;
  final _pages = const [HomeView(), SettingsView()]; //HistoryView(), , DbView()

  //TODO : Refactor to use a more robust state management solution
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = Provider.of<OnboardingViewModel>(context).state;

    // Show dialog if permission not granted & not already showing
    if (!_dialogShown && state != OnboardingState.granted && state != OnboardingState.error) {
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
    tracker.startListening();
  }

  @override
  Widget build(BuildContext context) {
    final granted = context.watch<OnboardingViewModel>().state == OnboardingState.granted;

    return granted
        ? _buildScaffold()
        : Stack(
            children: [
              _buildScaffold(),
              const Positioned.fill(child: ColoredBox(color: Colors.black45)),
            ],
          );
  }

  Scaffold _buildScaffold() => Scaffold(
    body: IndexedStack(index: _selectedPageIndex, children: _pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedPageIndex,
      onDestinationSelected: (i) => setState(() => _selectedPageIndex = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'History'),
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        NavigationDestination(icon: Icon(Icons.developer_mode), label: 'db view'),
      ],
    ),
  );
}

//TODO Remove when not debugging
class DbView extends StatelessWidget {
  const DbView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return DriftDbViewer(db);
  }
}
