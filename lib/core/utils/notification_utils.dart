import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils{
  NotificationUtils._();

  static NotificationUtils get instance => NotificationUtils._();
  factory NotificationUtils() => instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  init() async{
    // initialise the plugin. app_icon needs to be a added as a drawable
    // resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid
        = AndroidInitializationSettings('@drawable/ic_notification');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) async {
        });
  }

  void showNotification({String title, String body}) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        0, title ??'', body ?? '', platformChannelSpecifics);
  }
}