// lib/app.dart
import 'package:flutter/material.dart';
import 'package:goblin_go/features/home/location_viewmodel.dart';
import 'package:goblin_go/features/settings/settings_viewmodel.dart';
import 'package:goblin_go/services/location_service.dart';
import 'package:goblin_go/services/mapbox_service.dart';
import 'package:provider/provider.dart';

import 'app_shell.dart';
import 'features/onboarding/onboarding_viewmodel.dart';

class GoblinGoApp extends StatelessWidget {
  const GoblinGoApp({super.key});

  //TODO: Reinstate themeMode from settingsViewModel
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationViewModel(
            BackgroundLocationService.instance,
            MapboxService.instance,
          ),
        ),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
      ],
      child: MaterialApp(
        title: 'GoblinGo',
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
          scaffoldBackgroundColor: Colors.pink,
        ),
        home: const AppShell(), //TODO: Change to MainScaffold
      ),
    );
  }
}
