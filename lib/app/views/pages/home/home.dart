import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/app/views/pages/doctor/detail_doctor/dokter_detail.dart';
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
  String? profileImageUrl;

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
              displayName = FirebaseAuth.instance.currentUser!.displayName;
              profileImageUrl = FirebaseAuth.instance.currentUser!.photoURL;
              return doctor;
            }).toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _doctorList = [];
            displayName = FirebaseAuth.instance.currentUser!.displayName;
            profileImageUrl = FirebaseAuth.instance.currentUser!.photoURL;
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
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                title: Row(
                  children: [
                    Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.1),
                        color: CustomTheme.greyColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.1),
                        child: profileImageUrl != null
                            ? Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: w * 0.1,
                                color: CustomTheme.blueColor2,
                              ),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: w * 0.03,
                          ),
                        ),
                        Text(
                          '${displayName ?? ''}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: w * 0.065,
                    ),
                    onPressed: () {
                      // Handle notification icon tap
                    },
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: w * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Container(
                          width: w,
                          height: w * 0.4,
                          decoration: BoxDecoration(
                            color: CustomTheme.blueColor1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(w * 0.08),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(w * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ayo jaga',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.06,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        'kebersihan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.06,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        'gigimu!!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.06,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(right: w * 0.05),
                                  child: Image.asset(
                                    'assets/other/home_image.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: w * 0.05),
                      // Clinic Image Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Klinik Kami",
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Container(
                              height: h * 0.2,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(5, (index) {
                                  return Container(
                                    width: w * 0.3,
                                    margin: EdgeInsets.only(right: w * 0.03),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.05),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/other/clinic_image${index + 1}.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: w * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Doctor",
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Column(
                              children: _doctorList.map((doctor) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: w * 0.05),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
