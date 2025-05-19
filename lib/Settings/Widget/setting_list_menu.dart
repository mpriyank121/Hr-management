import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_management/Company_details/Company_details_screen.dart';
import '../../Holiday_List_Page/holiday_list_screen.dart';

class MenuListWidget extends StatelessWidget {
  const MenuListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem('Company Profile','assets/images/company_profile_icon.png',() {
        Get.to(() => CompanyDetailsScreen());
      }),
      _MenuItem('Holiday List', 'assets/images/holiday_list_icon.png',() {
        Get.to(() => holidaypage(title: '',));
      }),
      _MenuItem('Leave Request', 'assets/images/User_Remove.png',() {
        Get.to(() => CompanyDetailsScreen());
      })
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          leading: Image.asset(
            item.imagePath,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          title: Text(item.title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: item.onTap,
        );
      },
    );
  }
}

class _MenuItem {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  _MenuItem(this.title,  this.imagePath,this.onTap );
}
