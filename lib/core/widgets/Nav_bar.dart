import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/app_colors.dart';
import '../../features/Employees/employees_screen.dart';
import '../../features/Management/management_screen.dart';
import '../../features/Salary/salary_screen.dart';
import '../../features/Settings/setting_page.dart';



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ManagementScreen(),
    SalaryScreen(),
    EmployeesScreen(),
    SettingPage(title: '',)
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    // You can add controller logic here if needed.
    // Example:
    // if (index == 0) Get.find<HomeController>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 2) {
          setState(() {
            _selectedIndex = 2;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 0 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Image.asset(
                  height: 24,
                  width: 24,
                  "assets/images/clock.png",
                  color: _selectedIndex == 0 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 1 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Image.asset(
                  height: 24,
                  width: 24,
                  "assets/images/currency-rupee-circle.png",
                  color: _selectedIndex == 1 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Salary',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 2 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Image.asset(
                  height: 24,
                  width: 24,
                  "assets/images/users-03.png",
                  color: _selectedIndex == 2 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Employees',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 3 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Image.asset(
                  height: 24,
                  width: 24,
                  "assets/images/settings-02.png",
                  color: _selectedIndex == 3 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
