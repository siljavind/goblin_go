import 'package:flutter/material.dart';
import 'package:goblin_go/services/background_location_service.dart';
import 'package:goblin_go/services/mapbox_service.dart';
import 'package:goblin_go/ui/bottom_navigation.dart';
import 'package:goblin_go/view_models/location_viewmodel.dart';
import 'package:goblin_go/view_models/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class GoblinGoApp extends StatelessWidget {
  const GoblinGoApp({super.key});

  //TODO Revisit ChangeNotifierProvider usage
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
        ),
        home: const BottomNavigation(), //TODO: Change to MainScaffold
      ),
    );
  }
}
