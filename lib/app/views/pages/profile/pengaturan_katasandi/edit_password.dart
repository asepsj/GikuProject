import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/services/auth/logout.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class EditPasswordView extends StatefulWidget {
  const EditPasswordView({super.key});

  @override
  State<EditPasswordView> createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _updatePassword(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        await FirebaseAuth.instance.signOut();
        WeAlert.success(
          description: 'Kata sandi berhasil diubah. Silakan masuk kembali.',
          onTap: () {
            signOut(context);
          },
        );
      }
    } catch (e) {
      WeAlert.error(
        description: 'Terjadi kesalahan saat mengubah kata sandi. Coba lagi.',
      );
      print('Error updating password: $e');
    }
  }

  Future<void> _handleChangePassword() async {
    WeAlert.showLoading();
    final currentPassword = _currentPasswordController.text;
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      WeAlert.close();
      WeAlert.error(
        description: 'Semua kolom harus diisi',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      WeAlert.close();
      WeAlert.error(
        description: 'Kata sandi baru tidak cocok',
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await _updatePassword(newPassword);
      }
    } catch (e) {
      WeAlert.close();
      WeAlert.error(
        description: 'Kata sandi saat ini tidak valid',
      );
      print('Error reauthenticating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(w * 0.1),
            bottomRight: Radius.circular(w * 0.1),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Perbarui Kata Sandi',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: CustomTheme.blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kata Sandi Saat Ini',
              style: TextStyle(
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.02),
            TextField(
              controller: _currentPasswordController,
              obscureText: !_isCurrentPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi saat ini',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isCurrentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: w * 0.05),
            Text(
              'Kata Sandi Baru',
              style: TextStyle(
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.02),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi baru',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: w * 0.05),
            Text(
              'Konfirmasi Kata Sandi',
              style: TextStyle(
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.02),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Konfirmasi kata sandi baru',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: w * 0.05),
            Center(
              child: ElevatedButton(
                onPressed: _handleChangePassword,
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: CustomTheme.blueColor1,
                  padding: EdgeInsets.symmetric(
                      vertical: w * 0.02, horizontal: w * 0.1),
                  textStyle: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
