import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:intl/intl.dart';

class AntrianService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> tambahAntrian(
    BuildContext context,
    Map<dynamic, dynamic> doctor,
    DateTime date,
    int queueNumber,
    String userUid,
    String userName,
    String doctorName,
  ) async {
    WeAlert.showLoading();
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String key = _databaseReference.child('antrians').push().key!;
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd').format(now);
      Map<String, dynamic> queueData = {
        'doctor_key': doctor['key'],
        'user_key': userUid,
        'pasien_name': userName,
        'doctor_name': doctorName,
        'nomor_antrian': queueNumber,
        'status': 'dibuat',
        'date': formattedDate,
        'created_at': '${dateFormat}',
      };

      await _databaseReference.child('antrians').child(key).set(queueData);
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

  Future<bool> isQueueFull(final String doctorId, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    DatabaseReference queueRef =
        FirebaseDatabase.instance.ref().child('antrians');

    DataSnapshot snapshot = await queueRef.get();

    int count = 0;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;
      queues.forEach((key, value) {
        if (value['doctor_key'] == doctorId &&
            value['date'] == formattedDate &&
            value['status'] != 'batal') {
          count++;
        }
      });
    }

    return count >= 5;
  }

  Future<List<bool>> checkQueueNumbers(DateTime date, String doctorId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    DatabaseReference queueRef = _databaseReference.child('antrians');
    DataSnapshot snapshot = await queueRef.get();

    List<bool> isQueueTaken = List.filled(5, false);

    if (snapshot.value != null) {
      Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;
      for (int i = 0; i < 5; i++) {
        int nomor = i + 1;
        bool isTaken = queues.values.any(
          (value) =>
              value['date'] == formattedDate &&
              value['nomor_antrian'] == nomor &&
              value['doctor_key'] == doctorId &&
              value['status'] != 'batal',
        );
        isQueueTaken[i] = isTaken;
      }
    }
    return isQueueTaken;
  }

  Future<List<Map<String, dynamic>>> fetchUserQueues(String userId) async {
    List<Map<String, dynamic>> userQueues = [];

    try {
      DataSnapshot snapshot = await _databaseReference
          .child('antrians')
          .orderByChild('user_key')
          .equalTo(userId)
          .get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;

        queues.forEach((key, value) {
          if (value['status'] == 'dibuat' || value['status'] == 'berlangsung') {
            userQueues.add({
              'id': key,
              'date': value['date'],
              'nomor_antrian': value['nomor_antrian'],
              'doctor_name': value['doctor_name'],
              'status': value['status'],
              'queueNumber': value['queueNumber'],
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching user queues: $e');
    }

    return userQueues;
  }

  Future<List<Map<String, dynamic>>> fetchUserDoneQueues(String userId) async {
    List<Map<String, dynamic>> userQueues = [];

    try {
      DataSnapshot snapshot = await _databaseReference
          .child('antrians')
          .orderByChild('user_key')
          .equalTo(userId)
          .get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> queues = snapshot.value as Map<dynamic, dynamic>;

        queues.forEach((key, value) {
          if (value['status'] == 'batal' || value['status'] == 'selesai') {
            userQueues.add({
              'id': key,
              'date': value['date'],
              'nomor_antrian': value['nomor_antrian'],
              'doctor_name': value['doctor_name'],
              'status': value['status'],
              'queueNumber': value['queueNumber'],
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching user queues: $e');
    }

    return userQueues;
  }

  Future<void> cancelQueue(String queueId) async {
    WeAlert.showLoading();
    try {
      await _databaseReference.child('antrians').child(queueId).update({
        'status': 'batal',
      });

      WeAlert.close();
      WeAlert.success(
        description: 'antrian anda berhasil dibatalkan',
        onTap: () {
          WeAlert.close();
        },
      );
    } catch (e) {
      print('Error cancelling queue: $e');
    }
  }
}
