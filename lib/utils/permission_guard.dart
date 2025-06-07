import 'package:permission_handler/permission_handler.dart';

/// A utility class to ensure necessary permissions are granted before using location services.
class PermissionGuard {
  static Future<void> ensureLocation() async {
    final status = await Permission.locationAlways.request();
    //TODO: Handle no permission granted gracefully
    if (!status.isGranted) {
      throw Exception('GoblinGo needs location permission to work.');
    }
  }
}
