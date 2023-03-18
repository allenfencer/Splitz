import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/constants/text_theme.dart';

class UserCardTile extends StatefulWidget {
  final String id;
  final String name;
  final String number;
  final void Function(String) function;
  UserCardTile(
      {super.key,
      required this.id,
      required this.name,
      required this.number,
      required this.function});

  @override
  State<UserCardTile> createState() => _UserCardTileState();
}

class _UserCardTileState extends State<UserCardTile> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: CheckboxListTile(
          checkColor: Colors.white,
          activeColor: ColorTheme.purpleTile,
          title: Text(
            widget.name,
            style: TT.f16w600.copyWith(color: ColorTheme.textColor),
          ),
          subtitle: Text(
            widget.number,
            style: TT.f14w600.copyWith(color: Colors.grey.shade500),
          ),
          value: isChecked,
          onChanged: (val) {
            if (val!) {
              widget.function(widget.id);
            }
            setState(() {
              isChecked = val;
            });
          }),
    );
  }
}
