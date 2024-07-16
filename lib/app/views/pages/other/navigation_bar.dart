import 'package:flutter/material.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/app/views/pages/home/home.dart';
import 'package:giku/app/views/pages/profile/myprofile.dart';
import 'package:giku/app/views/pages/schedule/my_shedule/my_schedule.dart';
import 'package:giku/app/views/pages/notification/notification.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final routes = {
    '/HomePage': (BuildContext context) => HomeView(),
    '/SchedulePage': (BuildContext context) => MyScheduleView(),
    '/NotifPage': (BuildContext context) => NotificationView(),
    '/ProfilePage': (BuildContext context) => MyProfileView(),
  };
  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final w = MediaQuery.of(context).size.width;
    final screens =
        routes.values.map((pageBuilder) => pageBuilder(context)).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentPage,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: CustomTheme.blueColor1,
            ),
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.calendar_month,
              color: CustomTheme.blueColor1,
            ),
            icon: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.notifications,
              color: CustomTheme.blueColor1,
            ),
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
              color: CustomTheme.blueColor1,
            ),
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
