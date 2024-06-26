import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

var notifyMe = false;

Future handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  // showLocalNotification(message.notification!);

  print("Data");
  print("title : ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
  if (message.notification != null) {
    handleMessage(message);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleMessage(RemoteMessage? message) {
  if (message == null) return;


  // if (message.notification.title.toString() != null) {
    // Navigate to a certain route based on the message
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveRequests()));
    // Increment the badge count
    // Provider.of<BadgeProvider>(context, listen: false).incrementBadge();
  // }
  // if message data has a certain route specified go there , else no navigation allowed
  // if (message.notification!.title.toString() == "hi") {
    // print(message.notification!.title.toString());

//     navigatorKey.currentState
//         ?.push(MaterialPageRoute(builder: (context) => LeaveRequests()));
//   } else if (message.data["click"] == "admin") {
//     navigatorKey.currentState
//         ?.push(MaterialPageRoute(builder: (context) => LeaveRequestsAdmin()));
//   }
}

void showLocalNotification(RemoteNotification notification, Map<String, dynamic> payload) async {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: '@drawable/ic_launcher', // Replace with your app's launcher icon
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidChannel);

  await _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(payload),
  );
}


Future<void> initNotification(
    FlutterLocalNotificationsPlugin localNotifications) async {
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/ic_launcher');

  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print("Body: ${body}");
      });

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await localNotifications.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
    // print("Notification Response data");
    // print("${notificationResponse.id}");
    // print("${notificationResponse.payload}");
    // handleMessage(message);
    // if message data has a certain route specified go there , else no navigation allowed
    var payload = jsonDecode(notificationResponse.payload.toString());

    //   if (payload['click'] == "user") {
    //     navigatorKey.currentState
    //         ?.push(MaterialPageRoute(builder: (context) => LeaveRequests()));
    //   } else if (payload["click"] == "admin") {
    //     navigatorKey.currentState
    //         ?.push(MaterialPageRoute(builder: (context) => LeaveRequestsAdmin()));
    //   }
  });
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    handleMessage(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);


  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    showLocalNotification(message.notification!, message.data);
    handleMessage(message);
    print("object");
    print("Title : ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  });
}

class FirebaseApi {

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fCMToken', fCMToken!);
var token = prefs.getString("fCMToken");
    print('Token NOT: $token');
    // add token to database
    initPushNotifications();
    initNotification(_localNotifications);
  }
}
