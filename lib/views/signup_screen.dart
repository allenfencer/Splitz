import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/global%20widgets/custom_button.dart';
import 'package:splitz/views/home_screen.dart';
import 'package:splitz/views/login_screen.dart';
import 'package:splitz/views/more_details_screen.dart';

import '../constants/constants.dart';
import '../constants/text_theme.dart';
import '../services/auth_service.dart';
import '../services/firebase_services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void signupUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final user = await AuthService().signUpUserToFirebase(
          context, emailController.text, passwordController.text);

      if (user != null) {
        if (!mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MoreDetailsScreen()));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorTheme.backgroundColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TT.f40w600,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TT.f16w600,
                textAlignVertical: TextAlignVertical.center,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TT.f16w600.copyWith(fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
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
                    return 'Email cannot be empty';
                  } else if (!RegExp(emailPattern).hasMatch(value)) {
                    return 'Invalid email format';
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
                obscureText: true,
                style: TT.f16w600,
                textAlignVertical: TextAlignVertical.center,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TT.f16w600.copyWith(fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.lock),
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
                    return 'Password cannot be empty';
                  } else if (value.length < 8) {
                    return 'Password must be atleast 8 characters';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: CustomButton(
                isLoading: isLoading,
                buttonText: 'Sign up',
                function: signupUser,
              )),
              const SizedBox(
                height: 70,
              ),
              Center(
                  child: CustomButton(
                buttonText: 'Already have an account?',
                function: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
