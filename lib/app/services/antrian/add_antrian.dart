import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:intl/intl.dart';

class AddAntrianService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> tambahAntrian(
    BuildContext context,
    Map<dynamic, dynamic> doctor,
    DateTime date,
    int queueNumber,
    String userUid,
    String name,
  ) async {
    WeAlert.showLoading();
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String key = _databaseReference.child('antrians').push().key!;
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd').format(now);
      Map<String, dynamic> queueData = {
        'doctor_id': doctor['key'],
        'pasien_id': userUid,
        'nomor_antrian': queueNumber,
        'status': 'dibuat',
        'date': formattedDate,
        'created_at': '${dateFormat}',
        'name_pasien': name,
      };

      await _databaseReference.child('antrians').child(key).set(queueData);
      print("Antrian berhasil ditambahkan");
      // OwesomeNotificationService.showNotification(
      //   title: 'Antrian Ditambahkan',
      //   body:
      //       'Antrian nomor $queueNumber berhasil ditambahkan untuk tanggal ${DateFormat('dd MMM yyyy').format(date)}.',
      // );
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
}
