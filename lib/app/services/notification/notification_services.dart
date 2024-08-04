import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NotificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _subscription;

  Future<void> fetchNotifications(
      Function(List<Map<dynamic, dynamic>>) onUpdate, Function onError) async {
    final user = _auth.currentUser;
    if (user != null) {
      final notificationsRef = _database.child('notifications').child(user.uid);
      _subscription = notificationsRef.onValue.listen(
        (event) {
          final List<Map<dynamic, dynamic>> notifications = [];
          try {
            final data = event.snapshot.value as Map<dynamic, dynamic>?;
            if (data != null) {
              data.forEach(
                (key, value) {
                  if (value is Map) {
                    notifications.add({'id': key, ...value});
                  } else {
                    print('Unexpected data format for notification: $value');
                  }
                },
              );
              notifications
                  .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
            }
            onUpdate(notifications);
          } catch (e) {
            print('Error fetching notifications: $e');
            onError();
          }
        },
        onError: (error) {
          print('Stream error: $error');
          onError();
        },
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _database
          .child('notifications')
          .child(_auth.currentUser!.uid)
          .child(notificationId)
          .remove();
      print('Notification $notificationId deleted successfully');
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  String formatDate(int timestamp) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    return DateFormat('dd MMMM yyyy').format(date);
  }

  void cancelSubscription() {
    _subscription.cancel();
  }
}
