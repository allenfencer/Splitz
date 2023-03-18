import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';

import '../constants/text_theme.dart';

class CustomListTile extends StatelessWidget {
  final int? member;
  final String? title;
  const CustomListTile({super.key, this.title, this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      alignment: Alignment.center,
      height: 80,
      width: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(2, 2)),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title!,
            overflow: TextOverflow.ellipsis,
            style: TT.f20w600.copyWith(color: ColorTheme.purpleTile),
          ),
          const SizedBox(
            height: 5,
          ),
          Text('$member members', style: TT.f16w600)
        ],
      ),
    );
  }
}
