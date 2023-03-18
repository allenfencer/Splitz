import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_theme.dart';
import '../constants/text_theme.dart';

class CustomTextField extends StatelessWidget {
  final Function(String)? validator;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final TextInputType inputType;
  final IconData icon;
  Function? onChanged;

  CustomTextField(
      {super.key,
      this.validator,
      this.onChanged,
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
          onChanged: (val) {
            onChanged!;
          },
          controller: controller,
          validator: (value) {
            validator!;
          },
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
