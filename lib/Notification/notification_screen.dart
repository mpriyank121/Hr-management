import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/Salary/Widgets/salary_history_list.dart';
import 'package:hr_management/Salary/model/salary_model.dart';

import '../Assets/assets_screen.dart';
import '../Assets/models/asset_list_model.dart';
import '../widgets/App_bar.dart';
import '../widgets/Custom_tab_widget.dart';
import '../Configuration/app_spacing.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.title});
  final String title;

  @override
  State<NotificationScreen> createState() =>_NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TabControllerX tabController = Get.put(TabControllerX());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            CustomTabWidget(
              tabTitles: ["General", "Leave"],
              controller: tabController,
            ),

            AppSpacing.small(context),
          ],
        ),
      ),
    );
  }
}
