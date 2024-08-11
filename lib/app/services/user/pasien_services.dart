import 'package:firebase_database/firebase_database.dart';

class PasienService {
  Future<Map<String, dynamic>> getAllPatients() async {
    DatabaseReference patientsRef = FirebaseDatabase.instance.ref('pasiens');
    DatabaseEvent event = await patientsRef.once();

    if (event.snapshot.exists) {
      Map<String, dynamic> patients = {};
      for (var patient in event.snapshot.children) {
        patients[patient.key!] = patient.value as Map<dynamic, dynamic>;
      }
      return patients;
    }
    return {};
  }
}
