import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize Firebase Cloud Messaging and set up notification handling
  Future<void> initialize() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission();

    // Configure background message handling
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // Configure foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      if (message.notification != null) {
        _showNotification(message.notification?.title ?? '', message.notification?.body ?? '');
      }
    });

    // Get the token for FCM
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  // Background message handler (for when the app is in the background)
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling background message: ${message.notification?.title}');
  }

  // Show local notification for event
  Future<void> _showNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'event_channel_id',
        'Event Notifications',
        importance: Importance.max,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,  // notification id
      title,
      body,
      notificationDetails,
    );
  }
}
