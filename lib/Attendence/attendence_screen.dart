import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_management/Attendence/Models/leave_model.dart';
import 'package:hr_management/widgets/primary_button.dart';
import '../Configuration/app_spacing.dart';
import '../widgets/App_bar.dart';
import '../widgets/Custom_tab_widget.dart';
import '../widgets/leave_tile.dart';
import '../widgets/attendence_calender.dart';

class AttendancePage extends StatefulWidget {
   AttendancePage({super.key, required this.title});


  final String title;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TabControllerX tabController = Get.put(TabControllerX());

  int selectedTabIndex = 0; // 👈 added

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    // Initialize current month view

  }
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: Column(
              children: [Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [   const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/logo.png')),
                const SizedBox(height: 8),
                const Text("Company Logo", style: TextStyle(fontSize: 16)),],),

                CustomTabWidget(
                  tabTitles: ["Attendance", "Leave"],
                  controller: tabController,
                ),
                AppSpacing.small(context),
                // ✅ Leave Cards Section

                // 📅 Calendar Section
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: AttendanceCalendar(
                    onMonthChanged: onMonthChanged,
                    popOnDateTap: false, // <-- this controls the behavior inside the calendar

                  ),

                ),
                Obx(() {
                  return [
                    Container(), // Attendance tab content
                    LeaveListWidget(leaveList: LeaveModel.dummyLeaves), // Leave tab content
                  ][tabController.selectedIndex.value];
                }),
                PrimaryButton(text: 'Download Report')
              ],
            ),
          ),
        ),
      ),
    )) ;
  }
}
