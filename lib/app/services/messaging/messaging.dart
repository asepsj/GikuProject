import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:giku/app/services/notification/owesomenotification_services.dart';

class MessagingServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the FCM token
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received: ${message.notification}');
        if (message.notification != null) {
          RemoteNotification notification = message.notification!;
          print('Notification Title: ${notification.title}');
          print('Notification Body: ${notification.body}');
          createAwesomeNotification(notification);
        }
      });

      // Handle background and terminated state notifications
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Background message received: ${message.notification}');
    if (message.notification != null) {
      print('Notification added in background');
      RemoteNotification notification = message.notification!;
      print('Notification Title: ${notification.title}');
      print('Notification Body: ${notification.body}');
      // You can call createAwesomeNotification here as well if needed
    }
  }

  void createAwesomeNotification(RemoteNotification notification) {
    OwesomeNotificationService.showNotification(
      title: notification.title!,
      body: notification.body!,
    );
  }

  static int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
