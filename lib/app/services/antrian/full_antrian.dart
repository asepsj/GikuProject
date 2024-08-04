import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AntrianFull {
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
}
