import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/services/notification/notification_services.dart';
import 'package:giku/app/views/pages/notification/detail_notification.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<Map<dynamic, dynamic>> _notifications = [];
  final NotificationService _notificationService = NotificationService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    await _notificationService.fetchNotifications(
      (notifications) {
        setState(() {
          _notifications = notifications;
          isLoading = false;
        });
      },
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _notificationService.cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return isLoading
        ? Center(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Center(
                child: SpinKitCircle(
                  color: CustomTheme.blueColor1,
                  size: w * 0.2,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(w * 0.1),
                  bottomRight: Radius.circular(w * 0.1),
                ),
              ),
              title: Text(
                'Notifikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: CustomTheme.blueColor1,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Container(
              height: double.infinity,
              child: _notifications.isEmpty
                  ? Center(child: Text('Tidak ada notifikasi'))
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        final notificationId = notification['id'] as String;
                        final bool isRead =
                            notification['read'] as bool? ?? false;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Dismissible(
                            key: Key(notificationId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              try {
                                await _notificationService
                                    .deleteNotification(notificationId);
                                setState(() {
                                  _notifications.removeWhere(
                                      (notif) => notif['id'] == notificationId);
                                });
                              } catch (e) {
                                print(
                                    'Error removing notification from list: $e');
                              }
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isRead
                                    ? Colors.white
                                    : CustomTheme.blueColor3,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12.0),
                                title: Text(
                                  notification['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: w * 0.6,
                                      child: Text(
                                        notification['message'] ??
                                            'No Description',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        _notificationService.formatDate(
                                            notification['timestamp']),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationDetailView(
                                        notification: notification,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
