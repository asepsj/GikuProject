import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giku/app/services/messaging/messaging.dart';
import 'package:giku/app/services/notification/owesomenotification_services.dart';
import 'package:giku/app/views/pages/other/navigation_bar.dart';
import 'package:giku/app/views/pages/auth/login_views.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MessagingServices().initNotification();
  await OwesomeNotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome = LoginView();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _defaultHome = isLoggedIn ? MainPage() : LoginView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: _defaultHome,
      ),
    );
  }
}
