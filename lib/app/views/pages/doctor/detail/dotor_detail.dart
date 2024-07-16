import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final List<Map<String, String>> schedule = [
    {'day': 'Senin', 'time': '00.00 - 00.00'},
    {'day': 'Selasa', 'time': '01.00 - 02.00'},
    {'day': 'Rabu', 'time': '03.00 - 04.00'},
    {'day': 'Kamis', 'time': '05.00 - 06.00'},
    {'day': 'Jumat', 'time': '07.00 - 08.00'},
  ];

  bool hasActiveQueue = false;
  late DatabaseReference _queueReference;

  @override
  void initState() {
    super.initState();
    _initDatabaseReference();
    _startQueueListener();
  }

  void _initDatabaseReference() {
    final doctorKey = widget.doctor['key'];
    _queueReference = FirebaseDatabase.instance
        .reference()
        .child('doctors')
        .child(doctorKey)
        .child('antrian');
  }

  void _startQueueListener() {
    _queueReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> queues =
            event.snapshot.value as Map<dynamic, dynamic>;
        // Check if there is an active queue
        bool isActive = false;
        queues.forEach((key, value) {
          if (value['userUid'] == FirebaseAuth.instance.currentUser!.uid &&
              (value['status'] == 'dibuat' ||
                  value['status'] == 'disetujui' ||
                  value['status'] == 'berlangsung')) {
            isActive = true;
          }
        });
        if (mounted) {
          setState(() {
            hasActiveQueue = isActive;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            hasActiveQueue = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _queueReference.onDisconnect();
  }

  Future<bool> userHasActiveQueue() async {
    return hasActiveQueue;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final doctor = widget.doctor;
    return Scaffold(
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
                background: Image(
                  image: AssetImage('assets/other/doktor.png'),
                  fit: BoxFit.contain,
                ),
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
                          doctor['name'],
                          style: TextStyle(
                            fontSize: w * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          doctor['email'],
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
                          doctor['key'],
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
                        (item) => Container(
                          child: Text(
                            '${item['day']} : ${item['time']}',
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
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
                          'dokter.alamat',
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
                  // Handle case where user has active queue
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Anda sudah memiliki antrian aktif.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
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
