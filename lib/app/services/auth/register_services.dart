import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/pages/auth/login_views.dart';

class Register {
  final databaseReference = FirebaseDatabase.instance.ref();

  void addUser(
    String userId,
    String fullName,
    String email,
    String phoneNumber,
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
}
