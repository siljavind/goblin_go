import 'package:flutter/material.dart';

import '../views/history_view.dart';
import '../views/home_view.dart';
import '../views/settings/settings_view.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentPageIndex = 1;

  final _pages = const [HistoryView(), HomeView(), SettingsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (i) => setState(() => _currentPageIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'History',
          ),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
