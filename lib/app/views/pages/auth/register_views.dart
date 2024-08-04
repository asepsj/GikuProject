import 'package:flutter/material.dart';
import 'package:giku/app/services/auth/login_services.dart';
import 'package:giku/app/services/auth/register_services.dart';
import 'package:giku/app/views/components/button_component.dart';
import 'package:giku/app/views/components/input_component.dart';
import 'package:giku/app/views/components/input_password_component.dart';
import 'package:giku/app/views/pages/auth/widget/widget_register.dart';

final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _reenterPasswordController = TextEditingController();
final _phoneController = TextEditingController();

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool passwordVisible = false;
  bool reenterPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    // final _authService = AuthService();
    final _register = Register();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.35,
              child: WidgetRegister(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'Nama',
                      hintText: 'Nama Lengkap',
                      controller: _nameController,
                      icon: Icons.person_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'Email',
                      hintText: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'phone',
                      hintText: 'Nomor Handphone',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputPassword(
                      labelText: "Password",
                      hintText: "Password",
                      visible: passwordVisible,
                      controller: _passwordController,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputPassword(
                      labelText: "Reenter Password",
                      hintText: "Reenter Password",
                      controller: _reenterPasswordController,
                      visible: reenterPasswordVisible,
                      onPressed: () {
                        setState(() {
                          reenterPasswordVisible = !reenterPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(top: w * 0.05),
                    child: ButtonWidget(
                      text: "Daftar",
                      textColor: Colors.white,
                      onClicked: () {
                        _register.register(
                          context,
                          _nameController.text,
                          _emailController.text,
                          _phoneController.text,
                          _passwordController.text,
                          _reenterPasswordController.text,
                        );
                        _passwordController.clear();
                        _reenterPasswordController.clear();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
