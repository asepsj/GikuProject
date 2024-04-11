import 'package:giku/app/views/component/button_date_schedule.dart';
import 'package:giku/app/views/component/button_time_schedule.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

class addScheduleView extends StatefulWidget {
  const addScheduleView({super.key});

  @override
  State<addScheduleView> createState() => _addScheduleViewState();
}

class _addScheduleViewState extends State<addScheduleView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
          child: ButtonDateView(),
        ),
        Container(
          padding: EdgeInsets.only(top: w * 0.02, left: w * 0.05),
          child: Text(
            'Waktu',
            style: TextStyle(
              fontSize: w * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: w * 0.02),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(w * 0.02),
            child: ButtonTimeShedule(),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: w * 0.05),
          child: ElevatedButton(
            onPressed: () {},
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
        )
      ],
    );
  }
}
