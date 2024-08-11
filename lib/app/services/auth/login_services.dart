import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? fcmToken = await _firebaseMessaging.getToken();
        await prefs.setBool('isLoggedIn', true);
        await _updateUser(userCredential.user!.uid, fcmToken);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      WeAlert.close();
      WeAlert.error(description: '${e.message}');
    }
  }

  Future<void> _updateUser(String userId, String? fcmToken) async {
    try {
      DataSnapshot snapshot =
          await databaseReference.child("pasiens/$userId").get();
      if (snapshot.exists) {
        await databaseReference.child("pasiens/$userId").update(
          {
            'fcmToken': fcmToken,
          },
        );
      } else {
        print("User does not exist in the database.");
      }
    } catch (error) {
      print("Error updating user data: $error");
    }
  }
}
