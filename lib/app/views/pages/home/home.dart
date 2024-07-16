import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:giku/app/views/pages/doctor/detail/dotor_detail.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/app/views/pages/other/doctorlist.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('doctors');
  List<Map<dynamic, dynamic>> _doctorList = [];
  String? displayName;

  @override
  void initState() {
    super.initState();
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        if (mounted) {
          setState(() {
            _doctorList = data.entries.map((e) {
              final Map<dynamic, dynamic> doctor = e.value;
              doctor['key'] = e.key;
              return doctor;
            }).toList();
          });
        }
      }
    });
    _listenerUser();
  }

  void _listenerUser() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print(user.uid);
        if (mounted) {
          setState(() {
            print(user.email);
            print(user.displayName);
            displayName = user.displayName;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
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
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.045),
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
                      text1: doctor['name'] ?? '',
                      text2: doctor['email'] ?? '',
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DokterDetail(doctor: doctor),
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
