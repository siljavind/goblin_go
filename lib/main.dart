import 'package:flutter/material.dart';
import 'package:goblin_go/services/background_location_service.dart';
import 'package:goblin_go/utils/permission_guard.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionGuard.ensureLocation();
  await BackgroundLocationService.instance.init();
  runApp(const GoblinGoApp());
}
