import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goblin_go/services/settings_service.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async code before runApp
  await dotenv.load();
  await SettingsService().init();
  runApp(const GoblinGoApp());
}
