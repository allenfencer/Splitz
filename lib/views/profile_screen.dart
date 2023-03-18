import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splitz/constants/color_theme.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TT.f20w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(
                    child: CircleAvatar(
                  backgroundColor: ColorTheme.backgroundColor,
                  radius: 50,
                  // minRadius: 50,
                  // maxRadius: 70,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                )),
                const SizedBox(
                  height: 50,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    final email = FirebaseAuth.instance.currentUser!.email;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        // period: Duration(seconds: 5),
                        baseColor: Colors.grey.shade500,
                        highlightColor: Colors.white70,
                        child: SizedBox(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: 3,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Text(
                          'Name: ${snapshot.data!.get('name')}',
                          style:
                              TT.f18w400.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Email: $email',
                          style:
                              TT.f18w400.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Phone: ${snapshot.data!.get('phone')}',
                          style:
                              TT.f18w400.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    );
                  },
                ),
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
                const SizedBox(
                  height: 100,
                ),
              ]),
        ),
      ),
    );
  }
}
