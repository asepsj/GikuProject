import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/services/antrian/antrian_services.dart';
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
  final AntrianService antrianService = AntrianService();
  String? userid;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print(user.uid);
        if (mounted) {
          setState(() {
            userid = user.uid;
          });
        }
      }
    });
  }

  void addSchedule() async {
    if (selectedDate != null && nomorAntrian != null) {
      await antrianService.tambahAntrian(
          context, widget.doctor, selectedDate!, nomorAntrian!, userid!);
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
                      });
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: w * 0.02, left: w * 0.05),
                child: Text(
                  'Nomor antrian',
                  style: TextStyle(
                    fontSize: w * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: NomorAntrianView(
                  onNomorAntrianChanged: _onNomorAntrianChanged,
                  doctor: widget.doctor,
                  date: selectedDate!,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: w * 0.05, top: w * 0.1),
                child: ElevatedButton(
                  onPressed: selectedDate != null && nomorAntrian != null
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
