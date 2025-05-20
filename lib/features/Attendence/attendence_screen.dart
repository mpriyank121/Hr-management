import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../../core/widgets/attendence_calender.dart';
import '../../core/widgets/leave_tile.dart';
import '../../core/widgets/primary_button.dart';
import 'Models/leave_model.dart';


class AttendancePage extends StatefulWidget {
  AttendancePage({super.key, required this.title});

  final String title;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TabControllerX tabController = Get.put(TabControllerX());

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  void onMonthChanged(int year, int month) {
    setState(() {
      selectedYear = year;
      selectedMonth = month;
    });
  }

  void changeYear(int step) {
    setState(() {
      selectedYear += step;
    });
  }

  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                const SizedBox(height: 8),
                Text("Company Logo", style: FontStyles.subHeadingStyle()),
              ],
            ),
            const SizedBox(height: 16),
            CustomTabWidget(
              tabTitles: ["Attendance", "Leave"],
              controller: tabController,
            ),
            AppSpacing.small(context),

            // 📅 Calendar Section
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: AttendanceCalendar(
                onMonthChanged: onMonthChanged,
                popOnDateTap: false,
              ),
            ),

            const SizedBox(height: 16),

            Obx(() {
              return [
                Container(), // You can put actual attendance content here
                LeaveListWidget(leaveList: LeaveModel.dummyLeaves),
              ][tabController.selectedIndex.value];
            }),

            const SizedBox(height: 16),
            PrimaryButton(text: 'Download Report'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
