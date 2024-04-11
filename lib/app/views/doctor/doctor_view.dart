import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:giku/app/theme/custom_theme.dart';
import 'package:giku/app/views/doctor/schedule/add_schedule.dart';
import 'package:giku/app/views/other/doctorlist.dart';
import 'package:intl/date_symbol_data_local.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({super.key});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _selectedColor = Colors.black;
  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'Detail'),
    Tab(text: 'Jadwal'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
      body: Container(
        child: Column(
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
            SizedBox(
              height: w * 0.05,
            ),
            TabBar(
              controller: _tabController,
              tabs: _tabs,
              labelColor: _selectedColor,
              indicatorColor: _selectedColor,
              unselectedLabelColor: _unselectedColor.withOpacity(0.3),
              dividerColor: _unselectedColor.withOpacity(0.2),
              dividerHeight: w * 0.005,
              indicatorWeight: w * 0.005,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Text('Ini adalah Tab 2'),
                  ),
                  Container(
                    child: addScheduleView(),
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
