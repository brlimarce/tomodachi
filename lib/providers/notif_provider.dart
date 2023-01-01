import 'package:tomodachi/api/notif_api.dart';

class NotificationProvider {
  late NotificationAPI service;

  /// **********************************************
  /// * Constructor
  /// **********************************************

  NotificationProvider() {
    service = NotificationAPI();
    service.initializePlatformNotifications();
  }

  /// Display the local notification from the app
  /// to the device.
  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime deadline,
      required String payload}) async {
    await service.showLocalNotification(
        id: id, title: title, body: body, deadline: deadline, payload: payload);
  }

  Future<void> cancelNotification(int id) async {
    await service.cancelNotification(id);
  }
}
