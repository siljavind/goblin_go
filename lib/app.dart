// lib/app.dart
import 'package:flutter/material.dart';
import 'package:goblin_go/features/home/home_viewmodel.dart';
import 'package:goblin_go/features/settings/settings_viewmodel.dart';
import 'package:goblin_go/services/background/background_service.dart';
import 'package:goblin_go/services/notification_service.dart';
import 'package:goblin_go/services/settings_service.dart';
import 'package:goblin_go/services/tracking/mapbox_service.dart';
import 'package:goblin_go/services/tracking/session_tracker_service.dart';
import 'package:goblin_go/services/tracking/timer_service.dart';
import 'package:provider/provider.dart';

import 'app_shell.dart';
import 'data/local/app_database.dart';
import 'data/local/day_summaries_dao.dart';
import 'data/local/outdoor_sessions_dao.dart';
import 'features/onboarding/onboarding_viewmodel.dart';
import 'utils/goblin_theme.dart';

class GoblinGoApp extends StatelessWidget {
  const GoblinGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AppDatabase(), dispose: (_, db) => db.close()),
        Provider(create: (c) => DaySummariesDao(c.read<AppDatabase>())),
        Provider(create: (c) => OutdoorSessionsDao(c.read<AppDatabase>())),
        Provider<SettingsService>(create: (_) => SettingsService()),
        ChangeNotifierProvider(create: (c) => SettingsViewModel(c.read<SettingsService>())),
        ChangeNotifierProvider(create: (c) => HomeViewModel(c.read<DaySummariesDao>())),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        Provider<BackgroundService>(create: (_) => BackgroundService()),
        Provider<NotificationService>(
          create: (c) =>
              NotificationService(c.read<SettingsService>(), c.read<DaySummariesDao>())..init(),
          dispose: (_, s) => s.dispose(),
          lazy: false,
        ),
        Provider<MapboxService>(create: (_) => MapboxService()),
        Provider<TimerService>(create: (_) => TimerService()),

        ProxyProvider5<
          BackgroundService,
          MapboxService,
          TimerService,
          OutdoorSessionsDao,
          DaySummariesDao,
          SessionTrackerService
        >(
          update: (_, bg, mapbox, timer, sesDao, sumDao, _) => SessionTrackerService(
            backgroundService: bg,
            mapboxService: mapbox,
            timerService: timer,
            sessionsDao: sesDao,
            summariesDao: sumDao,
          ),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (_, vm, _) => MaterialApp(
          title: 'GoblinGo',
          theme: GoblinTheme.light,
          darkTheme: GoblinTheme.dark,
          themeMode: vm.themeMode,
          home: const AppShell(),
        ),
      ),
    );
  }
}
