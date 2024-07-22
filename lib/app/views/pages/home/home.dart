import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/doctor/detail_doctor/dokter_detail.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/app/views/pages/doctor/list_doctor/doctorlist.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  late StreamSubscription<DatabaseEvent> _databaseSubscription;
  List<Map<dynamic, dynamic>> _doctorList = [];
  String? displayName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loading();
  }

  @override
  void dispose() {
    _databaseSubscription.cancel();
    super.dispose();
  }

  void loading() {
    _databaseSubscription = _databaseReference
        .orderByChild('role')
        .equalTo('dokter')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        if (mounted) {
          setState(() {
            _doctorList = data.entries.map((e) {
              final Map<dynamic, dynamic> doctor = e.value;
              doctor['key'] = e.key;
              return doctor;
            }).toList();
            displayName = FirebaseAuth.instance.currentUser!.displayName;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _doctorList = [];
            displayName = FirebaseAuth.instance.currentUser!.displayName;
            isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      _databaseSubscription.cancel();
    });
    loading();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return isLoading
        ? Center(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Center(
                child: SpinKitCircle(
                  color: CustomTheme.blueColor1,
                  size: w * 0.2,
                ),
              ),
            ),
          )
        : RefreshIndicator(
            color: CustomTheme.blueColor1,
            onRefresh: _refresh,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: CustomTheme.blueColor1,
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
              body: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: w,
                        height: w * 0.4,
                        padding: EdgeInsets.only(left: w * 0.05),
                        decoration: BoxDecoration(
                          color: CustomTheme.blueColor1,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(w * 0.08),
                            bottomRight: Radius.circular(w * 0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Hi ${displayName?.getFirstName() ?? ''}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: w * 0.045),
                              ),
                            ),
                            SizedBox(height: w * 0.015),
                            Container(
                              child: Text(
                                'Ayo jaga',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.1,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            Container(
                              child: Text(
                                'kebersihan gigimu!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.1,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: w * 0.05,
                      ),
                      Column(
                        children: _doctorList.map((doctor) {
                          return Padding(
                            padding: EdgeInsets.all(w * 0.02),
                            child: DoctorList(
                              imagePath: 'assets/other/doktor.png',
                              text1: doctor['displayName'] ?? '',
                              text2: doctor['email'] ?? '',
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DokterDetail(doctor: doctor),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

extension StringExtension on String? {
  String getFirstName() {
    if (this == null) return '';
    List<String> names = this!.split(' ');
    if (names.isEmpty) return '';
    return '${names[0][0].toUpperCase()}${names[0].substring(1)}';
  }
}
