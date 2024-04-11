import 'package:flutter/material.dart';
import 'package:giku/app/views/auth/login_views.dart';
import 'package:giku/app/views/auth/widget/widget_register.dart';
import 'package:giku/app/views/component/button_component.dart';
import 'package:giku/app/views/component/input_component.dart';
import 'package:giku/app/views/component/input_password_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool passwordVisible = false;
  String _selectedRole = 'Pasien';
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(child: WidgetRegister()),
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
                          labelText: 'Nama',
                          hintText: 'Nama Lengkap',
                          icon: Icons.person_outlined),
                    ),
                    SizedBox(height: w * 0.05),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                      child: InputComponent(
                          labelText: 'Email',
                          hintText: 'Email',
                          icon: Icons.email_outlined),
                    ),
                    SizedBox(height: w * 0.05),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                      child: InputComponent(
                          labelText: 'phone',
                          hintText: 'Nomor Handphone',
                          icon: Icons.phone_outlined),
                    ),
                    SizedBox(height: w * 0.05),
                    Container(
                      width: w * 0.8,
                      padding: EdgeInsets.only(left: w * 0.05, right: w * 0.04),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(w * 0.1),
                          ),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text('Pilih jenis pengguna'),
                          ),
                          Container(
                            child: DropdownButton<String>(
                              value: _selectedRole.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRole = newValue!;
                                  print(_selectedRole);
                                });
                              },
                              items: <String>[
                                'Dokter',
                                'Pasien'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
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
                    SizedBox(height: w * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.only(top: w * 0.05),
                      child: ButtonWidget(
                          text: "Daftar",
                          textColor: Colors.white,
                          onClicked: () {}),
                    ),
                    SizedBox(height: w * 0.05),
                    Container(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                'Sudah memiliki akun?',
                                style: TextStyle(
                                    color: Colors.black,
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
                                            builder: (context) => LoginView()),
                                      );
                                    },
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                          color: Colors.black,
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
              ))
        ],
      ),
    );
  }
}
