import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CekNomorAntrian {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
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
}
