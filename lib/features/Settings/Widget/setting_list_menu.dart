import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/font_style.dart';
import '../../Company_details/Company_details_screen.dart';
import '../../Holiday_List_Page/holiday_list_screen.dart';
import '../../Leave_request/leave_approval_screen.dart';
import 'leave_page.dart';
import 'leave_request_form.dart';

class MenuListWidget extends StatelessWidget {
  const MenuListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem(
        'Company Profile',
        'assets/images/company_profile_icon.png',
            () async {
          final prefs = await SharedPreferences.getInstance();
          final phone = prefs.getString('user_phone') ?? '';
          Get.to(() => CompanyDetailsScreen(
            phone: phone,
            isEditMode: true,
          ));
        },
      ),
      _MenuItem(
        'Holiday List',
        'assets/images/holiday_list_icon.png',
            () => Get.to(() => HolidayPage(title: '')),
      ),
      _MenuItem(
        'Add Leaves',
        'assets/images/holiday_list_icon.png',
            () => Get.to(() => LeaveConfigScreen()),
      ),
      _MenuItem(
        'Create Leave',
        'assets/images/User_Remove.png',
            () => Get.to(() =>  RequestLeavePage()),
      ),
      _MenuItem(
        'Employee Leave Requests',
        'assets/images/User_Remove.png',
            () => Get.to(() =>  LeaveApprovalScreen()),
      ),

    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Image.asset(
            item.imagePath,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          title: Text(
            item.title,
            style: FontStyles.subHeadingStyle(fontSize: 15),
          ),
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

  _MenuItem(this.title, this.imagePath, this.onTap);
}
