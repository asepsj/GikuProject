import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:giku/app/views/auth/register_views.dart';
import 'package:giku/app/views/auth/widget/widget_login.dart';
import 'package:giku/app/views/component/button_component.dart';
import 'package:giku/app/views/component/input_component.dart';
import 'package:giku/app/views/component/input_password_component.dart';
import 'package:giku/app/views/home.dart';
import 'package:giku/app/views/other/navigation_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.white, automaticallyImplyLeading: false),
      body: Stack(
        children: [
          Container(child: MyWidget()),
          Positioned(
            top: w * 0.4,
            child: Container(
              width: w,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/other/logo1.png',
                width: w * 0.15,
              ),
            ),
          ),
          Positioned(
            top: w * 0.7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                        labelText: 'Enter email',
                        hintText: 'Email',
                        icon: Icons.email_outlined),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputPassword(
                      labelText: "Password",
                      hintText: "Password",
                      visible: passwordVisible,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(top: w * 0.05),
                    child: ButtonWidget(
                        text: "Masuk",
                        textColor: Colors.white,
                        onClicked: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: w * 0.2,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: w * 0.305,
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/other/logoGoogle.png',
                          width: w * 0.07,
                        ),
                        label: Text(
                          'Google',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.035),
                        )),
                  ),
                  SizedBox(height: w * 0.015),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Text(
                              'Tidak punya akun?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(left: w * 0.01),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterView()),
                                    );
                                  },
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
