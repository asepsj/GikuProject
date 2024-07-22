import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/auth/login_views.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signOut(BuildContext context) async {
  WeAlert.showLoading();
  try {
    await FirebaseAuth.instance.signOut();
    print("Logged out from Firebase successfully!");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    print("Error logging out from Firebase: $e");
  }
}
