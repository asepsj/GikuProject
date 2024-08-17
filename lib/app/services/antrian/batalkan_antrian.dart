import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/confirmation_dialog.dart';
import 'package:giku/app/views/alert/we_alert.dart';

class AntrianBatal {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Future<void> cancelQueue(
      BuildContext context, String queueId, VoidCallback route) async {
    bool confirm = await ConfirmationDialog.show(
      context,
      'Konfirmasi',
      'Apakah Anda yakin ingin membatalkan antrian ini?',
    );

    if (confirm) {
      WeAlert.showLoading();
      try {
        await _databaseReference.child('antrians').child(queueId).update({
          'status': 'batal',
        });

        WeAlert.close();
        WeAlert.success(
          description: 'Antrian Anda berhasil dibatalkan',
          onTap: () {
            route();
          },
        );
      } catch (e) {
        WeAlert.close();
        WeAlert.error(
          description: 'Terjadi kesalahan saat membatalkan antrian',
        );
        print('Error cancelling queue: $e');
      }
    }
  }
}
