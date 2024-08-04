import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDetailView extends StatefulWidget {
  final Map<dynamic, dynamic> notification;
  const NotificationDetailView({super.key, required this.notification});

  @override
  State<NotificationDetailView> createState() => _NotificationDetailViewState();
}

class _NotificationDetailViewState extends State<NotificationDetailView> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final notificationId = widget.notification['id'];
      final notificationRef = _database
          .child('notifications')
          .child(user.uid)
          .child(notificationId);
      await notificationRef.update({'read': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: w * 0.07),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: w * 0.05,
            ),
          ),
        ),
        title: Text(
          'Detail Notifikasi',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notification['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.03),
            Text(
              widget.notification['message'] ?? 'No Description',
              style: TextStyle(
                fontSize: w * 0.04,
              ),
            ),
            SizedBox(height: w * 0.03),
            Text(
              'Date: ${DateTime.fromMillisecondsSinceEpoch(widget.notification['timestamp'] * 1000).toLocal()}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// class NotificationDetailView extends StatelessWidget {
//   final Map<dynamic, dynamic> notification;

//   const NotificationDetailView({super.key, required this.notification});

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         leading: Container(
//           padding: EdgeInsets.only(left: w * 0.07),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: w * 0.05,
//             ),
//           ),
//         ),
//         title: Text(
//           'Detail Notifikasi',
//           style: TextStyle(
//             fontSize: w * 0.05,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(w * 0.07),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               notification['title'] ?? 'No Title',
//               style: TextStyle(
//                 fontSize: w * 0.045,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: w * 0.03),
//             Text(
//               notification['message'] ?? 'No Description',
//               style: TextStyle(
//                 fontSize: w * 0.04,
//               ),
//             ),
//             SizedBox(height: w * 0.03),
//             Text(
//               'Date: ${DateTime.fromMillisecondsSinceEpoch(notification['timestamp'] * 1000).toLocal()}',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
