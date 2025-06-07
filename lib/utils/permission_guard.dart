import 'package:permission_handler/permission_handler.dart';

/// A utility class to ensure necessary permissions are granted before using location services.
class PermissionGuard {
  static Future<void> ensureLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      throw Exception('GoblinGo needs location permission to work.');
    }

    //TODO: Handle gracefully if user denies permission. Also explain why we need it.
    status = await Permission.locationAlways.request();
    if (!status.isGranted) {
      throw Exception(
        'Please enable "Always" location so GoblinGo can log outdoor time in the background.',
      );
    }
  }
}
