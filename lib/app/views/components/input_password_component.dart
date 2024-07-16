import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputPassword extends StatelessWidget {
  final ValueChanged<String>? change;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  final String labelText;
  final String hintText;

  final IconData? icon;
  final Color? iconColor;
  final bool? withLabel;

  final VoidCallback? onPressed;
  final bool visible;

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  InputPassword({
    Key? key,
    this.change,
    this.onSaved,
    this.validator,
    required this.labelText,
    required this.hintText,
    this.onPressed,
    required this.visible,
    this.controller,
    this.icon,
    this.iconColor,
    this.withLabel,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TextFormField(
          inputFormatters: inputFormatters,
          keyboardType: keyboardType ?? TextInputType.emailAddress,
          onSaved: onSaved,
          onChanged: change,
          cursorColor: Colors.grey,
          validator: validator,
          obscureText: !visible,
          controller: controller,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.04,
              color: CustomTheme.blueColor1),
          decoration: InputDecoration(
            focusColor: CustomTheme.blueColor1,
            hintText: hintText,
            hintStyle: TextStyle(color: CustomTheme.blueColor1),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: w * 0.4,
              color: CustomTheme.blueColor1,
            ),
            contentPadding:
                EdgeInsets.fromLTRB(w * 0.05, w * 0.012, w * 0.012, w * 0.012),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.1),
              borderSide:
                  BorderSide(color: CustomTheme.blueColor1, width: w * 0.003),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.1),
              borderSide:
                  BorderSide(color: CustomTheme.blueColor1, width: w * 0.0035),
            ),
            suffixIcon: IconButton(
              focusColor: CustomTheme.blueColor1,
              color: CustomTheme.blueColor1,
              icon:
                  Icon(visible ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
