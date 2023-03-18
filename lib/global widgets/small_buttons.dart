import 'package:flutter/material.dart';

import '../constants/color_theme.dart';
import '../constants/text_theme.dart';

class SmallButtons extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonTitle;
  const SmallButtons({super.key, required this.buttonTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorTheme.textColor),
        child: Text(
          buttonTitle,
          style: TT.f16w600.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
