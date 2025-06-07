import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';

//TODO: DEPRECATED
class LocationCallbackHandler {
  static const String isolateName = 'LocatorIsolate';

  @pragma('vm:entry-point')
  static void callback(LocationDto locationDto) {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
  }

  @pragma('vm:entry-point')
  static void initCallback(Map<dynamic, dynamic> params) {
    // (Optional) any one-time initialization
  }

  @pragma('vm:entry-point')
  static void disposeCallback() {
    // (Optional) clean up resources
  }

  @pragma('vm:entry-point')
  static void notificationCallback() {
    // User tapped the notification; you could open your app, etc.
  }
}
