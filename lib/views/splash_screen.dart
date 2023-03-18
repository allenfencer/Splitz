import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/global%20widgets/custom_button.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/views/home_screen.dart';
import 'package:splitz/views/login_screen.dart';

import '../constants/text_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return SafeArea(
                child: Column(children: [
                  Image.asset(
                    'assets/images/splits_splash.png',
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: Text(
                      'Save your time\nand money',
                      style: TT.f30w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'Happy to share and save your time with transactions at home',
                        style: TT.f16w600.copyWith(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      width: 180,
                      child: CustomButton(
                          buttonText: 'Get started',
                          function: () async {
                            bool validToken =
                                await AuthService().checkTokenValidity();
                            if (validToken) {
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                    (route) => false);
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false);
                              }
                            }
                          }))
                ]),
              );
            } else {
              return const HomeScreen();
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
