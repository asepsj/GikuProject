import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:giku/app/views/pages/auth/login_views.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final databaseReference = FirebaseDatabase.instance.ref();
  final _firebaseMessaging = FirebaseMessaging.instance;

  void addUser(
    String userId,
    String fullName,
    String email,
    String phoneNumber,
    String? token,
  ) {
    databaseReference.child("pasiens/$userId").set(
      {
        'displayName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'fcm_token': token,
        'role': 'pasien',
        'createdAt': DateTime.now().toIso8601String(),
      },
    ).catchError(
      (error) {
        print("Error when adding user: $error");
      },
    );
  }

  Future<void> register(
    BuildContext context,
    String fullName,
    String email,
    String phoneNumber,
    String password,
    String reenterPass,
  ) async {
    WeAlert.showLoading();
    try {
      if (password != reenterPass) {
        WeAlert.close();
        WeAlert.error(
            description: "Kata sandi dan konfirmasi kata sandi tidak cocok.");
        return;
      }
      String? token = await _firebaseMessaging.getToken();
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(fullName);
      addUser(
        userCredential.user!.uid,
        fullName,
        email,
        phoneNumber,
        token,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } on FirebaseAuthException catch (e) {
      WeAlert.close();
      WeAlert.error(description: '${e.message}');
    }
  }

  Future<void> login(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    final email = emailController.text;
    final password = passwordController.text;
    WeAlert.showLoading();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? token = await _firebaseMessaging.getToken();
      if (userCredential.user != null && token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (Route<dynamic> route) => false,
        );
        databaseReference.child("pasiens/${userCredential.user!.uid}").update({
          'fcm_token': token,
        });
      }
    } on FirebaseAuthException catch (e) {
      WeAlert.close();
      WeAlert.error(description: '${e.message}');
    }
  }
}
