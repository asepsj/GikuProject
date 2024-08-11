import 'package:firebase_database/firebase_database.dart';

class DokterService {
  Future<Map<String, dynamic>> getAllDoctors() async {
    DatabaseReference doctorsRef = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event = await doctorsRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> doctors = {};
      for (var doctor in event.snapshot.children) {
        doctors[doctor.key!] = doctor.value as Map<dynamic, dynamic>;
      }
      return doctors;
    }
    return {};
  }
}
