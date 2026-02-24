import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:developer' as developer;

class NotificationManager {

  bool hasNotification = false;
  String? type;

  NotificationManager._privateConstructor();

  static final NotificationManager instance = NotificationManager._privateConstructor();

  void reset() {
    hasNotification = false;
    type = null;
  }

  void foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {
    // final notification = event.notification;
    // final x = notification.additionalData;
  }

  void clickListener(OSNotificationClickEvent ev) {
    final notification = ev.notification;
    String d = "Opened notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    developer.log(d);
  }

  Future<void> clearOneSignal() async {
    await OneSignal.User.removeTags(['user', 'guest-ticket']);
  }
}