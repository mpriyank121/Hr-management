import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/date_range_selector.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../Attendence/attendence_screen.dart';
import '../Employees/Widgets/department_employee_list.dart';
import '../Employees/controllers/employee_controller.dart';
import 'Widgets/Star_tile.dart';
import 'model/clock_in_model.dart';
import 'services/ClockInService.dart';
import 'Widgets/attendance_status_section.dart';
import 'Widgets/bordered_container.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final EmployeeController employeeController = Get.put(EmployeeController());
  List<ClockInModel> checkInList = [];
  List<ClockInModel> notCheckInList = [];
  List<ClockInModel> onLeave = [];

  @override
  void initState() {
    super.initState();
    ClockInService.fetchAttendanceStatus().then((data) {
      setState(() {
        checkInList = data['checkIN'] ?? [];
        notCheckInList = data['notcheckIN'] ?? [];
        onLeave = data['emp_on_leave'] ?? [];

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        title: 'Management',
        showTrailing: true,
      ),
      body: AppMargin(
        child: Obx(() {
          final totalEmployees = employeeController.employeeList.length;
          return ListView(
            children: [
              AppSpacing.small(context),
              BorderedContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Employees', style: FontStyles.subHeadingStyle()),
                    Text(
                      totalEmployees.toString(),
                      style: FontStyles.subHeadingStyle(
                          color: Color(0xFF12D18E)
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.small(context),
              AttendanceStatusSection(
                checkIn: checkInList,
                notCheckIn: notCheckInList,
                onLeave: onLeave,
              ),
              AppSpacing.small(context),
               // _attendanceStats(screenHeight),
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _workingHoursSection(),
                    AppSpacing.small(context),
                    DepartmentEmployeeList(
                      onTapRoute: (String empId) => AttendancePage(
                        title: '',
                        employeeId: empId,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _attendanceStats(double screenHeight) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.13,
                child: StatTile(
                  icon: Image.asset('assets/images/employee_leave_icon.png'),
                  percent: '12.8%',
                  title: 'Employees on Leave',
                  subtitle: 'Decreased vs last month',
                  percentColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.13,
                child: StatTile(
                  icon: Image.asset('assets/images/late_employee_con.png'),
                  percent: '6.8%',
                  title: 'Late Employees',
                  subtitle: 'Decreased vs last month',
                  percentColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.13,
                child: StatTile(
                  icon: Image.asset('assets/images/late_employee_con.png'),
                  percent: '6.8%',
                  title: 'Late Employees',
                  subtitle: 'Decreased vs last month',
                  percentColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _workingHoursSection() {
    final EmployeeController employeeController = Get.find<EmployeeController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text("Working Hours", style: FontStyles.subHeadingStyle()),
            Obx(() => Text(
              "Total ${employeeController.totalWorkingHours.value} hr",
              style: FontStyles.subTextStyle(color: Colors.green),
            )),
          ],
        ),
        DateRangeSelectorWidget(
          onDateRangeSelected: (start, end) {
            employeeController.fetchEmployeesWithDateRange(start, end);
          },
        ),
      ],
    );
  }

}
