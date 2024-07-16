import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({super.key});

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView> {
  int activeStep = 0;
  double progress = 0.2;

  void increaseProgress() {
    if (progress < 1) {
      setState(() => progress += 0.2);
    } else {
      setState(() => progress = 0);
    }
  }

  final List<Widget> stepContent = [
    Center(child: Text('Payment Content')),
    Center(child: Text('Shipping Content')),
    Center(child: Text('Order Details Content')),
    Center(child: Text('Finish Content')),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            EasyStepper(
              lineStyle: LineStyle(
                lineType: LineType.normal,
                unreachedLineType: LineType.dotted,
              ),
              activeStep: activeStep,
              direction: Axis.horizontal,
              unreachedStepIconColor: Colors.white,
              unreachedStepBorderColor: Colors.black54,
              finishedStepBackgroundColor: Colors.deepPurple,
              unreachedStepBackgroundColor: Colors.deepOrange,
              showTitle: true,
              onStepReached: (index) => setState(() => activeStep = index),
              steps: [
                EasyStep(
                  icon: Icon(Icons.money),
                  activeIcon: Icon(Icons.money),
                  title: 'Payment',
                ),
                EasyStep(
                  icon: Icon(Icons.local_shipping_outlined),
                  activeIcon: Icon(Icons.local_shipping_outlined),
                  title: 'Shipping',
                ),
                EasyStep(
                  icon: Icon(Icons.file_copy_outlined),
                  activeIcon: Icon(Icons.file_copy_outlined),
                  title: 'Order Details',
                ),
                EasyStep(
                  icon: Icon(Icons.check_circle_outline),
                  activeIcon: Icon(Icons.check_circle_outline),
                  title: 'Finish',
                ),
              ],
            ),
            SizedBox(height: 20),
            stepContent[activeStep],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increaseProgress,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
