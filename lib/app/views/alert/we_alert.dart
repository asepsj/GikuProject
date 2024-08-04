import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/views/components/custom_button.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/main.dart';

class WeAlert {
  static showLoading() async {
    return showDialog(
      context: MyApp.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return WillPopScope(
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
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  static error({String? description}) {
    showDialog(
      context: MyApp.navigatorKey.currentState!.context,
      barrierDismissible: true,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
          ),
          title: Column(
            children: [
              Icon(
                Icons.assignment_late_sharp,
                size: w * 0.2,
                color: CustomTheme.redColor,
              ),
              Text(
                "Gagal !!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomTheme.redColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.08,
                ),
              ),
            ],
          ),
          content: Text(
            description ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.04,
            ),
          ),
          actions: <Widget>[
            CustomButton(
              buttonColor: CustomTheme.redColor,
              title: "Ya",
              onTap: () {
                close();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  static success({String? description, VoidCallback? onTap}) {
    return showDialog(
      context: MyApp.navigatorKey.currentState!.context,
      barrierDismissible: true,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: w * 0.2,
                color: CustomTheme.successColor,
              ),
              Text(
                "Berhasil",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomTheme.successColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.08,
                ),
              ),
            ],
          ),
          content: Text(
            description ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.04,
            ),
          ),
          actions: <Widget>[
            CustomButton(
              buttonColor: CustomTheme.successColor,
              title: "Ya",
              onTap: onTap,
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  static close() {
    MyApp.navigatorKey.currentState!.pop();
  }
}
