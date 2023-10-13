import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings(('flutter_logo'));

//     var initalizationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification: (id, title, body, payload) async {});

//     var initalizationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initalizationSettingsIOS);

//     await notificationsPlugin.initialize(initalizationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails('channelId', 'channelName',
//          importance: Importance.max),
//     iOS: DarwinNotificationDetails()
//     );
//   }

//   Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(id, title, body, notificationDetails());
//   }
// }

class NotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidInitializationSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showLocalNotification(String title, String body) {
const androidNotificationDetail = AndroidNotificationDetails(
'0', // channel Id
'general' // channel Name
);
const iosNotificatonDetail = DarwinNotificationDetails();
const notificationDetails = NotificationDetails(
  iOS: iosNotificatonDetail,
  android: androidNotificationDetail,
);
_flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
}
}
