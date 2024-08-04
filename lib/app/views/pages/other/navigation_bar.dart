import 'package:flutter/material.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:giku/app/views/pages/home/home.dart';
import 'package:giku/app/views/pages/profile/my_profile/my_profile.dart';
import 'package:giku/app/views/pages/schedule/my_shedule/my_schedule.dart';
import 'package:giku/app/views/pages/notification/notification.dart';
import 'package:giku/app/services/notification/notification_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  int _unreadNotifications = 0;
  final NotificationService _notificationService = NotificationService();

  final routes = {
    '/HomePage': (BuildContext context) => HomeView(),
    '/SchedulePage': (BuildContext context) => MyScheduleView(),
    '/NotifPage': (BuildContext context) => NotificationView(),
    '/ProfilePage': (BuildContext context) => MyProfileView(),
  };

  @override
  void initState() {
    super.initState();
    _listenToNotifications();
  }

  void _listenToNotifications() {
    _notificationService.fetchNotifications(
      (notifications) {
        setState(() {
          _unreadNotifications = notifications.where((n) => !n['read']).length;
        });
      },
      () {
        setState(() {
          _unreadNotifications = 0;
        });
      },
    );
  }

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
            activeIcon: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  color: CustomTheme.blueColor1,
                ),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(w * 0.05),
                      ),
                      constraints: BoxConstraints(
                        minWidth: w * 0.03,
                        minHeight: w * 0.03,
                      ),
                      child: Text(
                        '$_unreadNotifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.02,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(w * 0.05),
                      ),
                      constraints: BoxConstraints(
                        minWidth: w * 0.03,
                        minHeight: w * 0.03,
                      ),
                      child: Text(
                        '$_unreadNotifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.02,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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

  @override
  void dispose() {
    _notificationService.cancelSubscription();
    super.dispose();
  }
}
