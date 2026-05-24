import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: settings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showBudgetAlert(
    double amount,
    double totalExpense,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'budget_alerts_channel',
          'Budget Alerts',
          channelDescription: 'Alerts when monthly budget is exceeded',
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFFEF4444),
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: 'Budget Exceeded! ',
      body:
          'Your expense of ₹${amount.toInt()} pushed your total to ₹${totalExpense.toInt()}..',
      notificationDetails: platformDetails,
    );
  }
}
