import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<NotificationView>
    with SingleTickerProviderStateMixin {
  final List<TimeOfDay> slots = [
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
  ];

  TimeOfDay selectedSlot = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
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
          'Notification',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: CustomTheme.blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
