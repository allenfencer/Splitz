import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitz/services/firebase_services.dart';
import 'package:splitz/views/home_screen.dart';

import '../constants/color_theme.dart';
import '../constants/text_theme.dart';
import '../global widgets/custom_button.dart';

class MoreDetailsScreen extends StatefulWidget {
  const MoreDetailsScreen({super.key});

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void updateUserDB() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseService().updateUserDetailsInFirebase(
        FirebaseAuth.instance.currentUser!.uid,
        nameController.text,
        phoneController.text);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let us know you a bit more',
              style: TT.f40w600,
            ),
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              style: TT.f16w600,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlignVertical: TextAlignVertical.center,
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  hintStyle: TT.f16w600.copyWith(fontWeight: FontWeight.w400),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: ColorTheme.backgroundColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey))),
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'name cannot be empty';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TT.f16w600,
              textAlignVertical: TextAlignVertical.center,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: TT.f16w600.copyWith(fontWeight: FontWeight.w400),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: ColorTheme.backgroundColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey))),
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Phone number cannot be empty';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: CustomButton(
                  isLoading: isLoading,
                  buttonText: 'Finish',
                  function: updateUserDB),
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      )),
    );
  }
}
