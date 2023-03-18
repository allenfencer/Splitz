import 'package:flutter/material.dart';
import '../constants/color_theme.dart';
import '../constants/text_theme.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final VoidCallback function;
  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.function,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorTheme.textColor),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              )
            : Text(
                buttonText,
                style: TT.f18w400.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
