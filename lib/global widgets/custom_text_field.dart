import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_theme.dart';
import '../constants/text_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final TextInputType inputType;
  final IconData icon;

  CustomTextField(
      {super.key,
      this.inputFormatters,
      required this.hintText,
      required this.icon,
      required this.inputType,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
         
          controller: controller,
          keyboardType: inputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TT.f16w600.copyWith(
                  color: Colors.grey.shade400, fontWeight: FontWeight.w400),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: ColorTheme.backgroundColor)),
    );
  }
}
