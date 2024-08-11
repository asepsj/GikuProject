import 'package:firebase_database/firebase_database.dart';

class UserAntrian {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Stream<DatabaseEvent> userQueuesStream(String userId) {
    return _databaseReference
        .child('antrians')
        .orderByChild('pasien_id')
        .equalTo(userId)
        .onValue;
  }
}
