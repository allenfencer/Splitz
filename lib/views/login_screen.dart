import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/constants/constants.dart';
import 'package:splitz/global%20widgets/custom_button.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/views/home_screen.dart';
import 'package:splitz/views/more_details_screen.dart';
import 'package:splitz/views/signup_screen.dart';

import '../constants/text_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final user = await AuthService().loginUserToFirebase(
          context, emailController.text, passwordController.text);
      if (!mounted) return;
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
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
                'Log in',
                style: TT.f40w600,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                style: TT.f16w600,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                buttonText: 'Login',
                function: loginUser,
              )),
              const SizedBox(
                height: 70,
              ),
              Center(
                  child: CustomButton(
                buttonText: 'Don\'t have an account?',
                function: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
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
