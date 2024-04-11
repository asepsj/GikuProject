import 'package:flutter/material.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({super.key});

  @override
  State<MyScheduleView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyScheduleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jadwal Saya')),
    );
  }
}
