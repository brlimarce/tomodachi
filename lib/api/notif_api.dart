import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tomodachi/utility/palette.dart';

class NotificationAPI {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> observer = BehaviorSubject();
  static const String icon = 'ic_app';

  /// Initialize the notification settings for
  /// each platform.
  Future<void> initializePlatformNotifications() async {
    // Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(icon);

    // IOS
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the local timezone for
    // the notifications.
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    // Initialize the local notifications.
    await _localNotifications.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  /// Handler for IOS when the device receives
  /// the local notification.
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    return;
  }

  /// Handler for all notifications to be added to
  /// the stream (or observer).
  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      observer.add(payload);
    }
  }

  /// Return the notification details for each platform.
  Future<NotificationDetails> _notificationDetails() async {
    // Android
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'channel id',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      largeIcon: DrawableResourceAndroidBitmap(icon),
      color: Palette.ORANGE,
    );

    // IOS
    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails(threadIdentifier: 'tomodachi_thread');

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      observer.add(details.payload!);
    }

    // Return the platform specifics for the notification.
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    return platformChannelSpecifics;
  }

  /// Display a schedule notification from the
  /// app to the device.
  Future<void> showLocalNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime deadline,
      required String payload}) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(deadline, tz.local)
            .subtract(const Duration(hours: 1)),
        platformChannelSpecifics,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  /// Cancel the app notification based on [id].
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
