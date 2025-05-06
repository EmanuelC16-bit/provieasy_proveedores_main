import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        debugPrint('Notification tapped: ${resp.payload}');
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'provieasy_channel',
      'ProvyEasy Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: 'some payload if you need',
    );
  }
}

// A GlobalKey you'll need to show that AlertDialog from onDidReceiveLocalNotification
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
