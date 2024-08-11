import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/services/antrian/batalkan_antrian.dart';
import 'package:giku/app/services/antrian/user_antrian.dart';
import 'package:giku/app/services/user/dokter_services.dart';
import 'package:giku/app/views/pages/schedule/detail_schedule/detai_schedule.dart';
import 'package:giku/app/views/pages/schedule/list_schedule/schedule_list.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:firebase_database/firebase_database.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({Key? key}) : super(key: key);

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView>
    with SingleTickerProviderStateMixin {
  final UserAntrian _antrianUser = UserAntrian();
  final AntrianBatal _antrianBatal = AntrianBatal();
  List<Map<dynamic, dynamic>> _queues = [];
  List<Map<dynamic, dynamic>> _queuesDone = [];
  final _tabs = [
    Tab(text: 'Berlangsung'),
    Tab(text: 'Selesai'),
  ];
  late TabController _tabController;
  final _selectedColor = Colors.black;
  final _unselectedColor = const Color(0xff5f6368);
  String? userUid;
  bool isLoading = true;
  StreamSubscription<DatabaseEvent>? _queuesSubscription;
  StreamSubscription<DatabaseEvent>? _queuesDoneSubscription;
  Map<String, dynamic> _doctorData = {};
  final DokterService _dokterService = DokterService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _queuesSubscription?.cancel();
    _queuesDoneSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _initializeUserUid();
    await _fetchDoctorData();
    await _subscribeToQueues();
    await _subscribeToDoneQueues();
  }

  Future<void> _fetchDoctorData() async {
    try {
      _doctorData = await _dokterService.getAllDoctors();
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  Future<void> _initializeUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid;
      });
    }
  }

  Future<void> _subscribeToQueues() async {
    if (userUid != null) {
      _queuesSubscription =
          _antrianUser.userQueuesStream(userUid!).listen((event) {
        final List<Map<dynamic, dynamic>> queues = event.snapshot.children
            .where((e) =>
                e.child('status').value == 'dibuat' ||
                e.child('status').value == 'berlangsung')
            .map((e) => {
                  'id': e.key,
                  ...e.value as Map<dynamic, dynamic>,
                  'doctor_name': _doctorData[e.child('doctor_id').value]
                          ?['displayName'] ??
                      'Tidak diketahui',
                  'doctor_photo':
                      _doctorData[e.child('doctor_id').value]?['foto'] ?? ''
                })
            .toList();
        if (mounted) {
          setState(() {
            _queues = queues;
            isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _subscribeToDoneQueues() async {
    if (userUid != null) {
      _queuesDoneSubscription =
          _antrianUser.userQueuesStream(userUid!).listen((event) {
        final List<Map<dynamic, dynamic>> queues = event.snapshot.children
            .where((e) =>
                e.child('status').value == 'batal' ||
                e.child('status').value == 'selesai')
            .map((e) => {
                  'id': e.key,
                  ...e.value as Map<dynamic, dynamic>,
                  'doctor_name': _doctorData[e.child('doctor_id').value]
                          ?['displayName'] ??
                      'Tidak diketahui',
                  'doctor_photo':
                      _doctorData[e.child('doctor_id').value]?['foto'] ?? ''
                })
            .toList();
        if (mounted) {
          setState(() {
            _queuesDone = queues;
            isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _cancelQueue(String queueId) async {
    await _antrianBatal.cancelQueue(context, queueId);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

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
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(w * 0.1),
                  bottomRight: Radius.circular(w * 0.1),
                ),
              ),
              title: Text(
                'Antrian saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: CustomTheme.blueColor1,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Container(
              padding: EdgeInsets.only(top: w * 0.035),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: _tabs,
                    labelColor: _selectedColor,
                    indicatorColor: _selectedColor,
                    unselectedLabelColor: _unselectedColor.withOpacity(0.3),
                    dividerColor: _unselectedColor.withOpacity(0.2),
                    dividerHeight: w * 0.005,
                    indicatorWeight: w * 0.005,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: w * 0.04),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(
                          child: _queues.isEmpty
                              ? const Center(
                                  child: Text('Tidak ada antrian tersedia'),
                                )
                              : ListView.builder(
                                  itemCount: _queues.length,
                                  itemBuilder: (context, index) {
                                    final antrian = _queues[index];
                                    final doctorName =
                                        _doctorData[antrian['doctor_id']]
                                                ?['displayName'] ??
                                            'Tidak diketahui';
                                    final doctorPhoto =
                                        _doctorData[antrian['doctor_id']]
                                                ?['foto'] ??
                                            '';
                                    return Container(
                                      padding: EdgeInsets.all(w * 0.04),
                                      child: ScheduleList(
                                        imagePath: doctorPhoto,
                                        text1: doctorName,
                                        text2: antrian['date'] ??
                                            'Tidak diketahui',
                                        status: antrian['status'],
                                        onCancel: () =>
                                            _cancelQueue(antrian['id']),
                                        detail: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailAntrian(
                                                      queueId: antrian['id']),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Center(
                          child: _queuesDone.isEmpty
                              ? const Center(
                                  child: Text('Tidak ada antrian tersedia'),
                                )
                              : ListView.builder(
                                  itemCount: _queuesDone.length,
                                  itemBuilder: (context, index) {
                                    final antrianDone = _queuesDone[index];
                                    final doctorName =
                                        _doctorData[antrianDone['doctor_id']]
                                                ?['displayName'] ??
                                            'Tidak diketahui';
                                    final doctorPhoto =
                                        _doctorData[antrianDone['doctor_id']]
                                                ?['foto'] ??
                                            '';
                                    return Container(
                                      padding: EdgeInsets.all(w * 0.02),
                                      child: ScheduleList(
                                        detail: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailAntrian(
                                                queueId: antrianDone['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        imagePath: doctorPhoto,
                                        text1: doctorName,
                                        text2: antrianDone['date'] ??
                                            'Tidak diketahui',
                                        status: antrianDone['status'],
                                        onCancel: () =>
                                            _cancelQueue(antrianDone['id']),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
