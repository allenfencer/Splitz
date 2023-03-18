import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:splitz/global%20widgets/custom_button.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/services/firebase_services.dart';
import 'package:splitz/views/login_screen.dart';

import '../constants/text_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TT.f20w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 228, 73, 62)),
                  child: TextButton.icon(
                      onPressed: () async {
                        await AuthService().logoutUserFromFirebase(context);
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Logout',
                        style: TT.f20w600.copyWith(color: Colors.white),
                      )),
                ),
                const Spacer(),
              ]),
        ),
      ),
    );
  }
}
