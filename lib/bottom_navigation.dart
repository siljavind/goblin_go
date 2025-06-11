import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:goblin_go/data/local/app_database.dart';

import 'features/history/history_view.dart';
import 'features/home/home_view.dart';
import 'features/settings/settings_view.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

//TODO: Add ability to swipe between pages
class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedPageIndex = 1;
  final _pages = const [HistoryView(), HomeView(), SettingsView(), DbView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}

class DbView extends StatelessWidget {
  const DbView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return DriftDbViewer(db);
  }
}
