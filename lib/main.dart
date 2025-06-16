import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme.dart';
import 'core/widgets/Nav_bar.dart';
import 'package:hr_management/features/Holiday_List_Page/controller/holiday_controller.dart';
import 'features/Welcome_page/welcome_page.dart';
import 'features/upgrade_screen/upgrade_plans.dart';
import 'features/Add_depart_and_employee/controller/department_type_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Put your controllers here
  Get.put(HolidayController());
  Get.put(DepartmentTypeController(), permanent: true);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomePage()),
        GetPage(name: '/UpgradePlanScreen', page: () => UpgradePlanScreen()),
        GetPage(name: '/home', page: () => MainScreen()),
      ],
    );
  }
}
