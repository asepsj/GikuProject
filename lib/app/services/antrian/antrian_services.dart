import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:intl/intl.dart';

class AntrianService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  Future<void> tambahAntrian(BuildContext context, Map<dynamic, dynamic> doctor,
      DateTime date, int queueNumber, String userUid) async {
    WeAlert.showLoading();
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String key = _databaseReference
          .child('doctors')
          .child(doctor['key'])
          .child('antrian')
          .push()
          .key!;
      Map<String, dynamic> queueData = {
        'doctor_key': doctor['key'],
        'userUid': userUid,
        'queueNumber': queueNumber,
        'status': 'dibuat',
        'date': formattedDate,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _databaseReference
          .child('doctors')
          .child(doctor['key'])
          .child('antrian')
          .child(key)
          .set(queueData);
      print("Antrian berhasil ditambahkan");

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Antrian Ditambahkan',
          body:
              'Antrian nomor $queueNumber berhasil ditambahkan untuk tanggal ${DateFormat('dd MMM yyyy').format(date)}.',
        ),
      );
      WeAlert.close();
      WeAlert.success(
          description: 'berhasil menambahkan antrian',
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) => false,
            );
          });
    } catch (error) {
      print("Gagal menambahkan antrian: $error");
    }
  }

  Future<bool> isQueueFull(
      final Map<dynamic, dynamic> doctor, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    DatabaseReference queueRef = _databaseReference
        .child('doctors')
        .child(doctor['key'])
        .child('antrian');

    DataSnapshot snapshot = await queueRef.get();

    int count = 0;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;
      queues.forEach((key, value) {
        if (value['date'] == formattedDate) {
          count++;
        }
      });
    }

    return count >= 5;
  }

  Future<List<bool>> checkQueueNumbers(
      final Map<dynamic, dynamic> doctor, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    DatabaseReference queueRef = _databaseReference
        .child('doctors')
        .child(doctor['key'])
        .child('antrian');
    DataSnapshot snapshot = await queueRef.get();

    List<bool> isQueueTaken = List.filled(5, false);

    if (snapshot.value != null) {
      Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;
      for (int i = 0; i < 5; i++) {
        int nomor = i + 1;
        bool isTaken = queues.values.any((value) =>
            value['date'] == formattedDate && value['queueNumber'] == nomor);
        isQueueTaken[i] = isTaken;
      }
    }

    return isQueueTaken;
  }
}
