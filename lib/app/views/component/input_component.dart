import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/theme/custom_theme.dart';

class InputComponent extends StatelessWidget {
  final ValueChanged<String>? change;
  final FormFieldSetter<String>? saved;
  final FormFieldValidator<String>? validator;

  final String labelText;
  final String hintText;
  final int? lines;

  final IconData? icon;
  final Color? iconColor;

  final GestureTapCallback? onTapIcon;
  final bool? enable;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;

  final bool? isRounded;
  final int? maxLength;
  final bool? isRequired;
  final String? initialValue;
  final TextInputType? keyboardType;

  final FocusNode? node;

  final TextEditingController? controller;

  InputComponent(
      {Key? key,
      this.change,
      this.saved,
      this.validator,
      required this.labelText,
      required this.hintText,
      this.keyboardType,
      this.controller,
      this.icon,
      this.onTapIcon,
      this.enable,
      this.lines,
      this.inputType,
      this.inputFormatters,
      this.isRounded,
      this.maxLength,
      this.isRequired,
      this.initialValue,
      this.iconColor,
      this.node})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        TextFormField(
          inputFormatters: inputFormatters,
          maxLines: lines != null ? null : 1,
          minLines: lines ?? 1,
          keyboardType: keyboardType ?? TextInputType.emailAddress,
          onSaved: saved,
          controller: controller,
          onChanged: change,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.04,
              color: CustomTheme.blueColor1),
          validator: validator,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: hintText,
            filled: enable ?? false,
            enabled: enable ?? true,
            hintStyle: TextStyle(color: CustomTheme.blueColor1),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusColor: CustomTheme.blueColor1,
            contentPadding:
                EdgeInsets.fromLTRB(w * 0.05, w * 0.012, w * 0.012, w * 0.012),
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
            suffixIcon: Icon(
              icon,
              color: iconColor ?? CustomTheme.blueColor1,
            ),
          ),
        ),
      ],
    );
  }
}
