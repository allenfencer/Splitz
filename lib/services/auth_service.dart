import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:splitz/services/firebase_services.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final storage =
      const FlutterSecureStorage(aOptions: AndroidOptions.defaultOptions);

  Future<bool> checkTokenValidity() async {
    bool validity = await storage.containsKey(key: 'token');
    if (validity) {
      return true;
    } else {
      return false;
    }
  }

  //FIRST TIME SIGNUP TO FIREBASE
  Future signUpUserToFirebase(
      BuildContext ctx, String email, String password) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await storage.write(key: 'userId', value: user.user!.uid);
      log(storage.read(key: 'userId').toString());
      FirebaseService().addUserToUserCollectionInFirebase(user.user!.uid);
      return user;
    } catch (e) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      Future.error(e.toString());
    }
  }

  //LOGIN EXISTING USER TO FIREBASE
  Future loginUserToFirebase(
      BuildContext ctx, String email, String password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await storage.write(key: 'userId', value: user.user!.uid);
      
      return user;
    } catch (e) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      Future.error(e.toString());
    }
  }

  //LOGOUT FUNCTION
  Future logoutUserFromFirebase(BuildContext ctx) async {
    try {
      storage.deleteAll();
      await auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      Future.error(e.toString());
    }
  }
}
