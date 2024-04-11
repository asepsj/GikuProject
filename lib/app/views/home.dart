import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:giku/app/views/other/doctorlist.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                        'Hi Stiven!',
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
              Container(
                child: DoctorList(
                    imagePath: 'assets/other/doktor.png',
                    text1: 'Dr. Sri Astuti',
                    text2: 'Dokter gigi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
