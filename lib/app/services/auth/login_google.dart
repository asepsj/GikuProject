import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginGoogle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();
  void addUser(
    String userId,
    String? fullName,
    String? email,
    String? phoneNumber,
  ) {
    databaseReference.child("pasiens/$userId").set(
      {
        'displayName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ).catchError(
      (error) {
        print("Error when adding user: $error");
      },
    );
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    WeAlert.showLoading();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        WeAlert.close();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final User? user = userCredential.user;
      await prefs.setBool('isLoggedIn', true);
      addUser(
        user!.uid,
        user.displayName,
        user.email,
        user.phoneNumber,
      );
      WeAlert.success(description: 'Login berhasil');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      WeAlert.close();
      WeAlert.error(description: '$e');
      print("Error signing in with Google: $e");
    }
  }
}
