import 'package:firebase_database/firebase_database.dart';

class AntrianDetail {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Future<Map<String, dynamic>?> fetchQueueDetails(String queueId) async {
    try {
      DataSnapshot snapshot =
          await _databaseReference.child('antrians').child(queueId).get();

      if (snapshot.value != null) {
        Map<String, dynamic> queueData =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        return queueData;
      }
    } catch (e) {
      print('Error fetching queue details: $e');
    }

    return null;
  }
}
