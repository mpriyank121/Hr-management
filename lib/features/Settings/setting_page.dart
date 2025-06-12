import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/App_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../login/login_screen.dart';
import 'Widget/setting_list_menu.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.title});
  final String title;
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Settings',
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/bc 3.svg'),
            onPressed: () {},
          ),
          showTrailing: true,

        ),
        body: Column(
          children: [
            MenuListWidget(),
            PrimaryButton(
              textColor: const Color(0xFFCD0909),
              buttonColor: const Color(0x19CD0909),
              text: 'Log Out',
              widthFactor: 0.9,
              heightFactor: 0.05,
              //buttonColor: const Color(0x19CD0909),
              icon: SvgPicture.asset(
                'assets/images/ant-design_logout-outlined.svg',
              ),
              onPressed: (){
                logout();

              },
            ),
          ],
        ),
      ),
    );
  }
}
