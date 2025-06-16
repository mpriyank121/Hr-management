import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/style.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Department_status_box.dart';
import '../Attendence/attendence_screen.dart';
import '../Employees/Widgets/department_employee_list.dart';
import '../Employees/controllers/employee_controller.dart';
import 'Widgets/Star_tile.dart';
import 'Widgets/bordered_container.dart';

class ManagementScreen extends StatelessWidget {
  final List<String> departments = ['Finance', 'Engineering', 'Human Resources'];
  final EmployeeController employeeController = Get.put(EmployeeController());

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
              // _attendanceStats(screenHeight),
              AppSpacing.small(context),
              BorderedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.small(context),
                    _workingHoursSection(),
                    AppSpacing.small(context),
                    DepartmentEmployeeList(
                      showEditButton: false,
                      onTapRoute: () => AttendancePage(title: ''),
                    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Working Hours", style: FontStyles.subHeadingStyle()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total 216 hr ", style: FontStyles.subTextStyle()),
            Text("This Month", style: FontStyles.subTextStyle()),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

}
