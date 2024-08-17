import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/services/dokter/jadwal_kerja.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/schedule/add_schedule/add_shedule.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class DokterDetail extends StatefulWidget {
  final Map<dynamic, dynamic> doctor;

  const DokterDetail({
    super.key,
    required this.doctor,
  });

  @override
  State<DokterDetail> createState() => _DokterDetailState();
}

class _DokterDetailState extends State<DokterDetail> {
  List<Map<String, dynamic>> schedule = [];

  bool hasActiveQueue = false;
  late DatabaseReference _queueReference;
  bool isLoading = true;
  late StreamSubscription<DatabaseEvent> _queueListener;
  final JadwalKerja _jadwalKerja = JadwalKerja();

  @override
  void initState() {
    super.initState();
    loading();
  }

  Future<void> loading() async {
    _initDatabaseReference();
    await _startQueueListener();
    await fetchDoctorsSchedules();
  }

  void _initDatabaseReference() {
    _queueReference = FirebaseDatabase.instance.ref().child('antrians');
  }

  Future<void> fetchDoctorsSchedules() async {
    Map<String, Map<String, dynamic>> schedules =
        await _jadwalKerja.fetchDoctorsSchedules(widget.doctor['key']);
    setState(() {
      schedule = schedules.values.toList();
      _sortScheduleByDay();
      isLoading = false;
    });
  }

  void _sortScheduleByDay() {
    const List<String> daysOrder = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    schedule.sort((a, b) {
      int dayIndexA = daysOrder.indexOf(a['day']);
      int dayIndexB = daysOrder.indexOf(b['day']);
      return dayIndexA.compareTo(dayIndexB);
    });
  }

  Future<void> _startQueueListener() async {
    _queueListener = _queueReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> queues =
            event.snapshot.value as Map<dynamic, dynamic>;
        bool isActive = false;
        queues.forEach((key, value) {
          if (value['pasien_id'] == FirebaseAuth.instance.currentUser!.uid &&
              (value['status'] == 'dibuat' ||
                  value['status'] == 'disetujui' ||
                  value['status'] == 'berlangsung')) {
            isActive = true;
            isLoading = false;
          }
        });
        if (mounted) {
          setState(() {
            hasActiveQueue = isActive;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            hasActiveQueue = false;
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() async {
    _queueListener.cancel();
    super.dispose();
  }

  Future<bool> userHasActiveQueue() async {
    return hasActiveQueue;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final doctor = widget.doctor;
    return isLoading
        ? Scaffold(
            body: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.white,
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
        : Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: Container(
                    padding: EdgeInsets.only(left: w * 0.025, top: w * 0.025),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: false,
                  expandedHeight: w * 0.9,
                  flexibleSpace: Container(
                    padding: EdgeInsets.only(top: w * 0.19),
                    child: FlexibleSpaceBar(
                      background: doctor['foto'] != null
                          ? Image.network(
                              doctor['foto']!,
                              width: w * 0.2,
                              height: h * 0.2,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, size: w * 1);
                              },
                            )
                          : Icon(Icons.person, size: w * 1),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(w * 0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(w * 0.08),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: w * 0.08, left: w * 0.08, right: w * 0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Dr. ${doctor['displayName']}' ?? '',
                                style: TextStyle(
                                  fontSize: w * 0.065,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Dokter Gigi',
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Divider(
                              height: w * 0.05,
                            ),
                            SizedBox(height: w * 0.07),
                            Container(
                              child: Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: ExpandableText(
                                doctor['description'] ??
                                    'tadak ada deskripsi dokter',
                                expandText: 'selengkapnya',
                                collapseText: 'Read Less',
                                linkColor: CustomTheme.blueColor1,
                                textAlign: TextAlign.justify,
                                maxLines: 5,
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Container(
                              child: Text(
                                'Jadwal',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...schedule.map(
                              (item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${item['day']} : ',
                                        style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      if (item['is_holiday'] != true) ...[
                                        Text(
                                          '${item['waktu_mulai'] ?? 'Tidak ditentukan'} - ${item['waktu_selesai'] ?? 'Tidak ditentukan'}',
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          'Libur',
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Container(
                              child: Text(
                                'Lokasi',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${doctor['alamat']}',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: w * 0.15,
              child: Center(
                child: SizedBox(
                  width: w * 0.9,
                  height: w * 0.1,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool hasActive = await userHasActiveQueue();
                      if (!hasActive) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddScheduleView(
                              doctor: doctor,
                            ),
                          ),
                        );
                      } else {
                        WeAlert.error(
                            description:
                                'Anda masih memiliki antrian yang aktif!');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasActiveQueue ? Colors.grey : CustomTheme.blueColor1,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.05),
                      ),
                    ),
                    child: Text(
                      'Buat Antrian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
