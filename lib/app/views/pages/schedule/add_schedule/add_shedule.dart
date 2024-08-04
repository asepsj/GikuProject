import 'dart:async';
import 'dart:ui';
import 'package:giku/app/services/antrian/cek_nomor.dart';
import 'package:giku/app/services/antrian/jadwal_libur_antrian.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/services/antrian/add_antrian.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/components/button_date_schedule.dart';
import 'package:giku/app/views/components/button_nomor_antrian.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class AddScheduleView extends StatefulWidget {
  final Map<dynamic, dynamic> doctor;
  const AddScheduleView({Key? key, required this.doctor}) : super(key: key);

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  DateTime? selectedDate = DateTime.now();
  int? nomorAntrian;
  final AddAntrianService antrianService = AddAntrianService();
  final CekNomorAntrian cekNomorAntrian = CekNomorAntrian();
  final JadwalLiburAntrian _jadwalLiburAntrian = JadwalLiburAntrian();
  late StreamSubscription<DatabaseEvent>? _queueListener;
  String? userid;
  String? userName;
  List<bool> isQueueTaken = List.filled(5, false);
  bool isQueueFull = false;
  bool isHoliday = false;
  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      userid = FirebaseAuth.instance.currentUser!.uid;
      userName = FirebaseAuth.instance.currentUser!.displayName;
    });
    _addQueueListener();
    _checkQueueNumbers();
  }

  Future<void> _checkQueueNumbers() async {
    if (selectedDate != null && widget.doctor['key'] != null) {
      // Check if the selected date is a holiday
      bool isHolidayToday = await _jadwalLiburAntrian.isDoctorOnHoliday(
          widget.doctor['key'], selectedDate!);
      if (mounted) {
        setState(() {
          isHoliday = isHolidayToday;
          if (isHoliday) {
            isQueueFull = false;
          } else {
            cekNomorAntrian
                .checkQueueNumbers(selectedDate!, widget.doctor['key'])
                .then((queueStatus) {
              setState(() {
                isQueueTaken = queueStatus;
                isQueueFull = !queueStatus.contains(false);
              });
            });
          }
        });
      }
    }
  }

  void _addQueueListener() {
    DatabaseReference queueRef =
        FirebaseDatabase.instance.ref().child('antrians');
    _queueListener = queueRef.onValue.listen((event) {
      _checkQueueNumbers();
    });
  }

  void addSchedule() async {
    if (selectedDate != null && nomorAntrian != null) {
      bool isQueueAvailable = !isQueueTaken[nomorAntrian! - 1];
      String? token = await _firebaseMessaging.getToken();

      if (isQueueAvailable && !isHoliday) {
        await antrianService.tambahAntrian(
          context,
          widget.doctor,
          selectedDate!,
          nomorAntrian!,
          userid!,
          userName!,
          widget.doctor['displayName'],
          token!,
        );
      } else if (isHoliday) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Dokter sedang libur pada hari ini. Pilih tanggal atau hari lain.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nomor antrian sudah terpakai atau dibatalkan.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih tanggal dan nomor antrian.'),
        ),
      );
    }
  }

  void _onNomorAntrianChanged(int nomor) {
    if (mounted) {
      setState(() {
        nomorAntrian = nomor;
      });
    }
  }

  @override
  void dispose() {
    _queueListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dokter',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.only(left: w * 0.07),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: w * 0.05,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: w * 0.05, right: w * 0.05, left: w * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: w * 0.23,
                      height: w * 0.23,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.035),
                        color: Color(0xFFFE8F8FF),
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: BackdropFilter(
                              blendMode: BlendMode.srcOver,
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: w * 0.2,
                                height: h * 0.2,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      CustomTheme.blueColor1.withOpacity(0.7),
                                      CustomTheme.blueColor1.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: w * 0.025),
                            child: Center(
                              child: Image.asset('assets/other/doktor.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: w * 0.4,
                      padding: EdgeInsets.only(left: w * 0.04, top: w * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Jenny Wilson',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: w * 0.04,
                            ),
                          ),
                          Text(
                            'Dokter Gigi',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: w * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.05),
              Container(
                padding: EdgeInsets.only(top: w * 0.05, left: w * 0.05),
                child: Text(
                  'Tanggal',
                  style: TextStyle(
                    fontSize: w * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: ButtonDateView(
                  doctor: widget.doctor,
                  onDateSelected: (date) async {
                    WeAlert.showLoading();
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.pop(context);
                    if (mounted) {
                      setState(() {
                        selectedDate = date;
                        nomorAntrian = null;
                        isHoliday = false; // Reset holiday status
                      });
                      _checkQueueNumbers();
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: w * 0.05, left: w * 0.05),
                child: Text(
                  'Nomor antrian',
                  style: TextStyle(
                    fontSize: w * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isHoliday
                  ? Center(
                      child: Container(
                        width: w * 0.7,
                        padding: EdgeInsets.only(top: w * 0.05),
                        child: Text(
                          'Dokter sedang libur pada hari ini. Pilih tanggal atau hari lain.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w * 0.045,
                            color: CustomTheme.blueColor1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : isQueueFull
                      ? Center(
                          child: Container(
                            width: w * 0.7,
                            padding: EdgeInsets.only(top: w * 0.05),
                            child: Text(
                              'Pada tanggal dan hari ini nomor antrian sudah penuh, Silahkan pilih tanggal lain.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: w * 0.045,
                                color: CustomTheme.blueColor1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: NomorAntrianView(
                            onNomorAntrianChanged: _onNomorAntrianChanged,
                            isQueueTaken: isQueueTaken,
                          ),
                        ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: w * 0.05, top: w * 0.05),
                child: ElevatedButton(
                  onPressed:
                      selectedDate != null && nomorAntrian != null && !isHoliday
                          ? () {
                              addSchedule();
                            }
                          : null,
                  child: Text(
                    'Tambahkan Jadwal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w * 0.7, w * 0.12),
                    backgroundColor: CustomTheme.blueColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
