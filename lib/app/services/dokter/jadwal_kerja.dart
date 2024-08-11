import 'package:firebase_database/firebase_database.dart';

class JadwalKerja {
  Future<Map<String, Map<String, dynamic>>> fetchDoctorsSchedules(
      String doctorId) async {
    final DatabaseReference scheduleRef =
        FirebaseDatabase.instance.ref().child('jam_kerja').child(doctorId);
    final snapshot = await scheduleRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      return data.map((key, value) {
        return MapEntry(key.toString(), Map<String, dynamic>.from(value));
      });
    }
    return {};
  }
}
