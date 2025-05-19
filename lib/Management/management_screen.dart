import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_management/Configuration/App_margin.dart';
import 'package:hr_management/Configuration/app_spacing.dart';
import 'package:hr_management/Management/Widgets/bordered_container.dart';
import 'package:hr_management/widgets/App_bar.dart';
import 'package:hr_management/widgets/Department_status_box.dart';
import '../Attendence/attendence_screen.dart';
import '../Configuration/font_style.dart';
import '../Employees/Widgets/department_employee_list.dart';
import '../Employees/dummy_data.dart';
import 'Widgets/Star_tile.dart';
import 'Widgets/department_widget.dart';
import 'Widgets/employee_clock_screen.dart';
import 'model/employee_model.dart';

class ManagementScreen extends StatelessWidget {
  final List<String> departments = ['Finance', 'Engineering', 'Human Resources'];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),        title: 'Management',
        showTrailing: true,


      ),
      body: AppMargin(child: ListView(
        children: [
          AppSpacing.small(context),
          _buildStatusSection(context),
          AppSpacing.small(context),
          _attendanceStats( screenHeight),
          AppSpacing.small(context),
          BorderedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _workingHoursSection(),
                AppSpacing.small(context),
                DepartmentEmployeeList(
                  onTapRoute: () => AttendancePage(title: ''),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final allEmployees = DummyData.departmentWiseEmployees.values.expand((e) => e).toList();

    final statusColorMap = {
      EmployeeStatus.notClockedIn: const Color(0xFFF54336),
      EmployeeStatus.clockedIn: const Color(0xFF1A96F0),
      EmployeeStatus.onLeave: const Color(0xFF607D8A),
    };

    final boxes = <Widget>[];

    for (var status in [EmployeeStatus.clockedIn, EmployeeStatus.notClockedIn, EmployeeStatus.onLeave]) {
      final filtered = allEmployees.where((e) => e.status == status).toList();
      if (filtered.isNotEmpty) {
        boxes.add(
            DepartmentStatusBox(
              title: _statusLabel(status),
              borderColor: statusColorMap[status]!,
              employees: filtered, // filtered is List<Employee>
            ));

        }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing = 12;
        double boxWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(boxes.length, (i) {
            return SizedBox(
              width: boxWidth,
              child: boxes[i],
            );
          }),
        );
      },
    );
  }


  Widget _attendanceStats(double screenHeight) {

    return Column(
      children: [
        // First Row with 2 tiles
        Row(
          children: [
            Expanded(
              child:SizedBox(
                height: screenHeight * 0.13, // 20% of screen height
                child: StatTile(
                icon: Image.asset('assets/images/employee_leave_icon.png'),
                percent: '12.8%',
                title: 'Employees on Leave',
                subtitle: 'Decreased vs last month',
                percentColor: Colors.green,
              ),)
            ),
            SizedBox(width: 12),
            Expanded(

              child:SizedBox(
                height: screenHeight * 0.13, // 20% of screen height
                child: StatTile(
                icon: Image.asset('assets/images/late_employee_con.png'),
                percent: '6.8%',
                title: 'Late Employees',
                subtitle: 'Decreased vs last month',
                percentColor: Colors.red,
              ),)
            ),
          ],
        ),
        SizedBox(height: 12),

        // Second Row with 1 tile
        Row(
          children: [
            Expanded(
              child:SizedBox(
                height: screenHeight * 0.13, // 20% of screen height

                child: StatTile(
                icon:Image.asset('assets/images/late_employee_con.png'),
                percent: '6.8%',
                title: 'Late Employees',
                subtitle: 'Decreased vs last month',
                percentColor: Colors.red,
              ), )
            ),
          ],
        ),
      ],
    );
  }


  Widget _workingHoursSection() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Working Hours", style: FontStyles.subHeadingStyle()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total 216 hr  90%", style: FontStyles.subTextStyle()),
            Text("This Month", style: FontStyles.subTextStyle()),
          ],
        ),
        SizedBox(height: 8),
      ],
    );

  }
  String _statusLabel(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.notClockedIn:
        return "Not Clocked In";
      case EmployeeStatus.clockedIn:
        return "Clocked In";
      case EmployeeStatus.onLeave:
        return "On Leave";
    }
  }

}
