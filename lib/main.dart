import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async code before runApp
  await dotenv.load();
  runApp(const GoblinGoApp());
}
