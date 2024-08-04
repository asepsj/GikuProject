import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:giku/app/services/antrian/add_antrian.dart';
import 'package:giku/app/views/pages/schedule/detail_schedule/detai_schedule.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class ScheduleList extends StatelessWidget {
  final String? imagePath;
  final String text1;
  final String text2;
  final String status;
  // final String queueId;
  final Function onCancel;
  final VoidCallback detail;

  const ScheduleList({
    Key? key,
    required this.imagePath,
    required this.text1,
    required this.text2,
    required this.status,
    // required this.queueId,
    required this.detail,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    return Container(
      height: w * 0.25,
      width: w * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: w * 0.02,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: detail,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.035),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: w * 0.25,
                height: w * 0.25,
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
                        child: imagePath != null
                            ? Image.network(
                                imagePath!,
                                width: w * 0.2,
                                height: h * 0.2,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person, size: w * 0.1);
                                },
                              )
                            : Icon(Icons.person, size: w * 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: w * 0.65,
                padding: EdgeInsets.only(top: w * 0.02),
                child: Stack(
                  children: [
                    ListTile(
                      title: Text(
                        'Dr. $text1',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text2,
                            style: TextStyle(
                              fontSize: w * 0.038,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: w * 0.038,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: status == "dibuat",
                      child: Positioned(
                        bottom: w * 0.02,
                        right: 0,
                        child: Container(
                          width: w * 0.24,
                          height: w * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              onCancel();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.red, width: w * 0.003),
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
