import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/theme.dart';
import 'core/widgets/Nav_bar.dart';
import 'features/Welcome_page/welcome_page.dart';
import 'features/upgrade_screen/upgrade_plans.dart';

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
