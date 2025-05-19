import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/login/login_screen.dart';
import 'package:hr_management/upgrade_screen/upgrade_plans.dart';
import 'package:hr_management/widgets/Nav_bar.dart';
import 'Configuration/theme.dart';
import 'Welcome_page/welcome_page.dart';
import 'onboarding/onboarding_screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>  WelcomePage()),
        GetPage(name: '/UpgradePlanScreen', page: () => UpgradePlanScreen()),
        GetPage(name: '/home', page: () => MainScreen()),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}
