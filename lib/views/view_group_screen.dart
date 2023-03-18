import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/views/split_bill_screen.dart';

import '../constants/text_theme.dart';
import '../services/firebase_services.dart';

class ViewGroupScreen extends StatelessWidget {
  final String groupName;
  final String groupId;
  final int noOfMembers;
  const ViewGroupScreen(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.noOfMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.textColor,
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SplitBillScreen(
                        noOfMembers: noOfMembers,
                        groupId: groupId,
                      )));
        },
      ),
      appBar: AppBar(
        title: Text(
          groupName,
          style: TT.f20w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15, top: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              alignment: Alignment.center,
              width: double.infinity,
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
                    '250',
                    overflow: TextOverflow.ellipsis,
                    style: TT.f20w600.copyWith(color: ColorTheme.purpleTile),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('FOOD', style: TT.f16w600)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
