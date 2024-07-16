import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final Function()? onTap;
  const CustomButton({Key? key, this.title = "", this.onTap, this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w * 0.3,
      height: w * 0.1,
      child: ElevatedButton(
        onPressed: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: w * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.05),
          ),
        ),
      ),
    );
  }
}
