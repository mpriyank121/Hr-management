import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../../core/widgets/attendence_calender.dart';
import '../../core/widgets/leave_card.dart';
import '../../core/widgets/leave_tile.dart';
import '../../core/widgets/primary_button.dart';
import 'Models/leave_model.dart';
import 'package:hr_management/features/Employees/controllers/employee_controller.dart';
import '../Leave_request/controllers/leave_request_controller.dart';
import '../Leave_request/models/LeaveRequestModel.dart';

class AttendancePage extends StatefulWidget {
  final String title;
  final String employeeId;

  const AttendancePage({
    Key? key,
    required this.title,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final tabController = Get.put(TabControllerX());
  final EmployeeController employeeController = Get.find<EmployeeController>();
  final LeaveRequestController leaveController = Get.put(LeaveRequestController());

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  Map<String, int> attendanceStatusCount = {
    "present": 0,
    "absent": 0,
    "halfday": 0,
  };

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
  void initState() {
    super.initState();
    leaveController.fetchLeavesRequests();
  }

  @override
  Widget build(BuildContext context) {
    final employee = employeeController.getEmployeeById(widget.employeeId);

    return Scaffold(
      appBar: CustomAppBar(
        title: employee?.name ?? widget.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (employee != null) Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(employee.avatarUrl),
                ),
                const SizedBox(height: 8),
                Text(employee.name, style: FontStyles.subHeadingStyle()),
                Text(employee.empCode, style: FontStyles.subTextStyle()),
              ],
            ),
            const SizedBox(height: 16),
            CustomTabWidget(
              tabTitles: ["Attendance", "Leave"],
              controller: tabController,
            ),
            AppSpacing.small(context),
            _buildLeaveCards(),

            // 📅 Calendar Section
            Container(
              child: AttendanceCalendar(
                onStatusCountChanged: (newCount) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      attendanceStatusCount = newCount;
                    });
                  });
                },
                onMonthChanged: onMonthChanged,
                popOnDateTap: false,
                employeeId: widget.employeeId,
              ),
            ),

            const SizedBox(height: 16),

            Obx(() {
              if (tabController.selectedIndex.value == 0) {
                return Container(); // Attendance content
              } else {
                // Leave content
                if (leaveController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (leaveController.errorMessage.isNotEmpty) {
                  return Center(child: Text(leaveController.errorMessage.value));
                }

                final leavesForEmployee = leaveController.leaveList
                    .where((leave) => leave.empName == employee?.name)
                    .toList();

                final leavesInMonth = leavesForEmployee.where((leave) {
                  if (leave.leaveStartDate == null) return false;
                  try {
                    final startDate = DateTime.parse(leave.leaveStartDate!);
                    return startDate.year == selectedYear &&
                        startDate.month == selectedMonth;
                  } catch (e) {
                    return false;
                  }
                }).toList();

                if (leavesInMonth.isEmpty) {
                  return const Center(
                      child: Text("No leave records found for this month."));
                }

                return Column(
                  children: leavesInMonth
                      .map((leave) => LeaveListWidget(
                            leaveList: [
                              LeaveModel(
                                leaveName: leave.leaveName ?? 'N/A',
                                startDate: leave.leaveStartDate ?? '',
                                endDate: leave.leaveEndDate ?? '',
                                status: leave.status ?? '',
                                comment: leave.comment ?? '',
                                resson: leave.reason ?? '',
                              )
                            ],
                          ))
                      .toList(),
                );
              }
            }),

          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCards() {
    final employee = employeeController.getEmployeeById(widget.employeeId);
    return Obx(() {
      if (tabController.selectedIndex.value == 0) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                LeaveCard(
                  title: "Present",
                  count: attendanceStatusCount["present"].toString(),
                ),
                LeaveCard(
                  title: "Absent",
                  count: attendanceStatusCount["absent"].toString(),
                  backgroundColor: const Color(0x19C13C0B),
                  borderColor: const Color(0xFFC13C0B),
                ),
                LeaveCard(
                  title: "Half Day",
                  count: attendanceStatusCount["halfday"].toString(),
                  backgroundColor: const Color(0x1933B2E9),
                  borderColor: const Color(0xFF33B2E9),
                ),
              ],
            ),
          ),
        );
      } else {
        final leavesForEmployee = leaveController.leaveList
            .where((leave) => leave.empName == employee?.name)
            .toList();
        final leavesInMonth = leavesForEmployee.where((leave) {
          if (leave.leaveStartDate == null) return false;
          try {
            final startDate = DateTime.parse(leave.leaveStartDate!);
            return startDate.year == selectedYear &&
                startDate.month == selectedMonth;
          } catch (e) {
            return false;
          }
        }).toList();

        int sickLeaves = leavesInMonth
            .where((l) =>
                l.leaveName?.toLowerCase().contains('sick') ?? false)
            .length;
        int casualLeaves = leavesInMonth
            .where((l) =>
                l.leaveName?.toLowerCase().contains('casual') ?? false)
            .length;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                LeaveCard(
                  title: "Sick Leave",
                  count: sickLeaves.toString(),
                  backgroundColor: const Color(0x19C13C0B),
                  borderColor: const Color(0xFFC13C0B),
                ),
                LeaveCard(
                  title: "Casual Leave",
                  count: casualLeaves.toString(),
                  backgroundColor: const Color(0x1933B2E9),
                  borderColor: const Color(0xFF33B2E9),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
