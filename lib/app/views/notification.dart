import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';

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
        title: Text('Pilih Slot Waktu'),
      ),
      body: Container(
        padding: EdgeInsets.all(w * 0.02),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Menentukan jumlah kolom
            crossAxisSpacing: 2.0, // Spasi antar kolom
            mainAxisSpacing: 5.0, // Spasi antar baris
            childAspectRatio: 3.0, // Rasio lebar ke tinggi setiap item
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSlot = slot;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedSlot == slot ? Colors.green : Colors.blue,
                ),
                child: Text(
                  '${slot.hour}:${slot.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
