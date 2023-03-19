import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/global%20widgets/custom_button.dart';
import 'package:splitz/global%20widgets/custom_text_field.dart';
import 'package:splitz/models/user_model.dart';

import '../constants/text_theme.dart';
import '../global widgets/user_card_tile.dart';
import '../services/firebase_services.dart';
import 'home_screen.dart';

class SplitBillScreen extends StatefulWidget {
  final String? groupId;
  final int? noOfMembers;
  const SplitBillScreen({super.key, this.groupId, this.noOfMembers});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController splitTitleController = TextEditingController();
  TextEditingController userSearchController = TextEditingController();
  bool splitEqually = false;

  final userRef = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Bill',
          style: TT.f20w600,
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            CustomTextField(
              hintText: 'Enter total amount',
              icon: Icons.currency_rupee,
              inputType: TextInputType.number,
              controller: amountController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: 'What is it for?',
              icon: Icons.edit_square,
              inputType: TextInputType.text,
              controller: splitTitleController,
            ),
            CheckboxListTile(
                enabled: false,
                checkColor: Colors.white,
                activeColor: ColorTheme.purpleTile,
                contentPadding: const EdgeInsets.only(left: 5, bottom: 5),
                title: const Text('Split Equally'),
                value: true,
                onChanged: (val) {
                  setState(() {
                    splitEqually = val!;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            CustomButton(
                buttonText: 'Split Bill',
                function: () async {
                  if (amountController.text.isEmpty &&
                      splitTitleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Cannot create an empty bill')));
                    return;
                  }
                  final splitAmount = double.parse(amountController.text) /
                      (widget.noOfMembers!);
                  List paidMembers = [FirebaseAuth.instance.currentUser!.uid];
                  await FirebaseService()
                      .addBillToGroup(
                          widget.groupId!,
                          amountController.text,
                          splitTitleController.text,
                          splitAmount.toStringAsFixed(2),
                          paidMembers)
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false));
                }),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      )),
    );
  }
}
