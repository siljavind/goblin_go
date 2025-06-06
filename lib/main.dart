import 'package:flutter/material.dart';
import 'views/settings_screen.dart';
import 'views/home_screen.dart';
import 'views/history_screen.dart';

void main() {
  runApp(const GoblinGoApp());
}

class GoblinGoApp extends StatelessWidget {
  const GoblinGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'GoblinGo',
      theme: ThemeData(
        // useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MainScaffold()
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>{
  int currentPageIndex = 1;

  static const List<Widget> _pages = [
    HistoryScreen(),
    HomeScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages
      ),
    );
  }
}
