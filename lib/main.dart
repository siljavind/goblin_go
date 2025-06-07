import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'location_callback_handler.dart';
import 'view_models/location_viewmodel.dart';
import 'view_models/settings_viewmodel.dart';
import 'views/history_screen.dart';
import 'views/home_screen.dart';
import 'views/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundLocator.initialize();

  final port = ReceivePort();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    LocationCallbackHandler.isolateName,
  );

  BackgroundLocator.registerLocationUpdate(
    LocationCallbackHandler.callback,
    initCallback: LocationCallbackHandler.initCallback,
    disposeCallback: LocationCallbackHandler.disposeCallback,
    autoStop: false,
    iosSettings: IOSSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      distanceFilter: 5,
      stopWithTerminate: false,
    ),
    androidSettings: AndroidSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      interval: 30,
      distanceFilter: 5,
      client: LocationClient.google,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'GoblinGo Location Updates',
        notificationTitle: 'GoblinGo is running',
        notificationMsg: 'Collecting location updates…',
        notificationIcon: '',
        //TODO: Check if necessary
        notificationTapCallback: LocationCallbackHandler.notificationCallback,
      ),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final vm = LocationViewModel();
            port.listen(vm.onLocationData, onError: vm.onError);
            return vm;
          },
        ),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: const GoblinGoApp(),
    ),
  );
}

class GoblinGoApp extends StatelessWidget {
  const GoblinGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsViewModel>().themeMode;
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'GoblinGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentPageIndex = 1;

  static const List<Widget> _pages = [
    HistoryScreen(),
    HomeScreen(),
    SettingsScreen(),
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
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: _pages),
    );
  }
}
