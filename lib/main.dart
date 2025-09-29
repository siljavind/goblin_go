import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goblin_go/services/settings_service.dart';

import 'app.dart';
import 'data/local/app_database.dart';
import 'data/local/database_seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async code before runApp
  await dotenv.load();
  await SettingsService().init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GoblinGoApp());

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((value) => runApp(const GoblinGoApp()));
}
