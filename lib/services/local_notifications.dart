import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
    );
  }
  // static Future init({bool initScheduled = false}) async {
  //   final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final settings = InitializationSettings(android: android);
  //   await _notifications.initialize(
  //     settings,
  //     on
  //   )
  // }
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
          id,
          title,
          body,
          await _notificationDetails(),
          payload: payload,
      );
  // static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  // static void initialize() {
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: AndroidInitializationSettings("@mipmap/ic_launcher"));
  //   _notificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse: (payload) {
  //     print("Notification payload: $payload");
  //   });
  //   // _notificationsPlugin.
  // }
  //
  // static void showNotificationOnForeground(RemoteMessage message) {
  //   final notificationDetail = NotificationDetails(
  //       android: AndroidNotificationDetails("com.example.my_app", "my_app",
  //           importance: Importance.max, priority: Priority.high));
  //
  //   _notificationsPlugin.show(
  //       DateTime.now().microsecond,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetail,
  //       payload: message.data["message"]);
  // }
}
