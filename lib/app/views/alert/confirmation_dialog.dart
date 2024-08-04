import 'package:flutter/material.dart';
import 'package:giku/app/views/components/custom_button.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class ConfirmationDialog {
  static Future<bool> show(
      BuildContext context, String title, String content) async {
    final w = MediaQuery.of(context).size.width;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
          ),
          title: Column(
            children: [
              Icon(
                Icons.help_outline,
                size: w * 0.2,
                color: CustomTheme.blueColor1,
              ),
              Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomTheme.blueColor1,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.08,
                ),
              ),
            ],
          ),
          content: Text(
            content ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: w * 0.04,
            ),
          ),
          actions: <Widget>[
            CustomButton(
              buttonColor: Colors.grey[400],
              title: "Tidak",
              onTap: () {
                Navigator.of(context).pop(false);
              },
            ),
            CustomButton(
              buttonColor: CustomTheme.blueColor1,
              title: "Ya",
              onTap: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
