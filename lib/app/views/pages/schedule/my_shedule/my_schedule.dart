import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/services/antrian/antrian_services.dart';
import 'package:giku/app/views/pages/schedule/list_schedule/schedule_list.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({Key? key}) : super(key: key);

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView>
    with SingleTickerProviderStateMixin {
  final AntrianService _antrianService = AntrianService();
  List<Map<dynamic, dynamic>> _queues = [];
  List<Map<dynamic, dynamic>> _queuesDone = [];
  final _tabs = [
    Tab(text: 'Berlangsung'),
    Tab(text: 'Selesai'),
  ];
  late TabController _tabController;
  final _selectedColor = Colors.black;
  final _unselectedColor = Color(0xff5f6368);
  String? userUid;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _initializeUserUid();
    await _fetchUserQueues();
    await _fetchUserDoneQueues();
    isLoading = false;
  }

  Future<void> _initializeUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid;
      });
    }
  }

  Future<void> _fetchUserQueues() async {
    if (userUid != null) {
      List<Map<dynamic, dynamic>> queues =
          await _antrianService.fetchUserQueues(userUid!);
      if (mounted) {
        setState(() {
          _queues = queues;
        });
      }
    }
  }

  Future<void> _fetchUserDoneQueues() async {
    if (userUid != null) {
      List<Map<dynamic, dynamic>> queues =
          await _antrianService.fetchUserDoneQueues(userUid!);
      if (mounted) {
        setState(() {
          _queuesDone = queues;
        });
      }
    }
  }

  Future<void> _cancelQueue(String queueId) async {
    await _antrianService.cancelQueue(queueId);
    await _fetchUserQueues();
    await _fetchUserDoneQueues();
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
                              ? Center(
                                  child: Text('Tidak ada antrian tersedia'),
                                )
                              : ListView.builder(
                                  itemCount: _queues.length,
                                  itemBuilder: (context, index) {
                                    final antrian = _queues[index];
                                    return Container(
                                      padding: EdgeInsets.all(w * 0.04),
                                      child: ScheduleList(
                                        imagePath: "imagePath",
                                        text1: "${antrian['doctor_name']}" ??
                                            'Tidak diketahui',
                                        text2: antrian['date'] ??
                                            'Tidak diketahui',
                                        status: antrian['status'],
                                        // queueId: antrian['id'],
                                        onCancel: () =>
                                            _cancelQueue(antrian['id']),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Center(
                          child: _queuesDone.isEmpty
                              ? Center(
                                  child: Text('Tidak ada antrian tersedia'),
                                )
                              : ListView.builder(
                                  itemCount: _queuesDone.length,
                                  itemBuilder: (context, index) {
                                    final antrianDone = _queuesDone[index];
                                    return Container(
                                      padding: EdgeInsets.all(w * 0.02),
                                      child: ScheduleList(
                                        imagePath: "imagePath",
                                        text1:
                                            "${antrianDone['doctor_name']}" ??
                                                '',
                                        text2: antrianDone['date'] ?? '',
                                        status: antrianDone['status'],
                                        // queueId: antrianDone['id'],
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
