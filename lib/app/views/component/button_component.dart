import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final bool? enable;
  final String? iconAsset;
  final bool? isLoading;

  final BoxShadow? boxShadow;
  final bool? withBoxShadow;

  final Color? color;
  final Color? bgColor;
  final Color? textColor;

  ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color,
    this.enable = true,
    this.bgColor,
    this.textColor,
    this.iconAsset,
    this.boxShadow,
    this.withBoxShadow,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          primary: Colors.white,
          backgroundColor: enable == false
              ? CustomTheme.greyColor
              : bgColor ?? CustomTheme.blueColor1,
        ),
        onPressed: enable == false ? () {} : onClicked,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
