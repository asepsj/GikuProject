import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class JadwalLiburAntrian {
  Map<String, String> englishToIndonesianDays = {
    'Monday': 'Senin',
    'Tuesday': 'Selasa',
    'Wednesday': 'Rabu',
    'Thursday': 'Kamis',
    'Friday': 'Jumat',
    'Saturday': 'Sabtu',
    'Sunday': 'Minggu',
  };

  String getIndonesianDayName(DateTime date) {
    String dayNameInEnglish = DateFormat('EEEE').format(date);
    return englishToIndonesianDays[dayNameInEnglish] ?? '';
  }

  Future<bool> isDoctorOnHoliday(String doctorId, DateTime date) async {
    final DatabaseReference scheduleRef =
        FirebaseDatabase.instance.ref().child('jam_kerja').child(doctorId);
    final DatabaseReference holidayRef =
        FirebaseDatabase.instance.ref().child('jadwal_libur').child(doctorId);

    // Format the date for searching in the database
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    // Fetch the doctor's holiday schedule
    DataSnapshot holidaySnapshot = await holidayRef.get();
    Map<dynamic, dynamic> holidays = holidaySnapshot.value != null
        ? holidaySnapshot.value as Map<dynamic, dynamic>
        : {};

    // Fetch the doctor's work schedule
    DataSnapshot scheduleSnapshot = await scheduleRef.get();
    Map<dynamic, dynamic> schedules = scheduleSnapshot.value != null
        ? scheduleSnapshot.value as Map<dynamic, dynamic>
        : {};

    // Check if the date is a holiday in the holiday schedule
    bool isHoliday = holidays.values.any((holiday) {
      return holiday['tanggal_libur'] == formattedDate;
    });

    // Convert the date to Indonesian day name for schedule comparison
    String dayNameInIndonesian = getIndonesianDayName(date);

    // Check if the doctor has a holiday schedule on that date
    bool doctorHasHoliday = schedules.values.any((schedule) {
      return schedule['day'] == dayNameInIndonesian &&
          schedule['is_holiday'] == true;
    });

    return isHoliday || doctorHasHoliday;
  }
}
