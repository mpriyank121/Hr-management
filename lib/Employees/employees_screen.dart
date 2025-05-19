import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_management/Configuration/App_margin.dart';
import 'package:hr_management/Configuration/app_spacing.dart';
import 'package:hr_management/Management/Widgets/bordered_container.dart';
import 'package:hr_management/widgets/App_bar.dart';
import '../Add_depart_and_employee/department_form.dart';
import '../Add_depart_and_employee/new_employee_form.dart';
import '../Configuration/font_style.dart';
import '../Management/Widgets/employee_clock_screen.dart';
import '../Management/model/employee_model.dart';
import '../widgets/Pie_chart.dart';
import '../widgets/floating_action_button.dart';
import 'Widgets/department_employee_list.dart';
import 'dummy_data.dart';
import 'employee_detail.dart';

class EmployeesScreen extends StatelessWidget {
  EmployeesScreen({super.key});

  String _statusToString(EmploymentStatus status) {
    switch (status) {
      case EmploymentStatus.permanent:
        return 'Permanent';
      case EmploymentStatus.contract:
        return 'Contract';
      case EmploymentStatus.intern:
        return 'Intern';
      case EmploymentStatus.partTime:
        return 'Part-Time';
    }
  }

  @override
  Widget build(BuildContext context) {
    void _handleMenuSelection(String value) {
      if (value == 'department') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddNewDepartmentScreen()),
        );
      } else if (value == 'employee') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewEmployeeForm()),
        );
      }
    }

    final allEmployees = DummyData.dummyEmployees;

    Map<String, double> statusCount = {};
    for (var status in EmploymentStatus.values) {
      final count = allEmployees.where((e) => e.employmentStatus == status).length;
      if (count > 0) {
        statusCount[_statusToString(status)] = count.toDouble();
      }
    }

    final colors = [
      Colors.pink.shade300,
      Colors.blue.shade300,
      Colors.orange.shade300,
      Colors.black87,
    ];

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        title: 'Employees',
        showTrailing: true,
      ),
      body: AppMargin(child: ListView(
        children: [
          AppSpacing.small(context),
          _buildStatusSection(context),
          AppSpacing.small(context),
          BorderedContainer(
            child: ExpansionTile(
              title: Text(
                'Employee Status',
                style: FontStyles.subHeadingStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              children: [
                BorderedContainer(
                  child: PieChartWidget(
                    dataMap: statusCount,
                    colorList: colors,
                    centerText: '${allEmployees.length}\nTotal Employees',
                    chartRadius: 120,
                    showLegend: true,
                    showChartValues: false,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.small(context),
         BorderedContainer(child:  DepartmentEmployeeList(
           showEditButton: true,
           onTapRoute: () => EmployeeDetail(title: ''),
         ),),
          AppSpacing.small(context),
        ],
      )),
      floatingActionButton: FloatingActionButtonWithMenu(
        onMenuItemSelected: _handleMenuSelection,
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final departmentMap = DummyData.departmentWiseEmployees;

    final Map<String, Color> departmentColors = {
      'Product': Color(0xFF1A96F0),
      'Engineering': Color(0xFFF54336),
      'UI/UX': Color(0xFF4CAF50),
    };

    final boxes = <Widget>[];

    departmentMap.forEach((department, employees) {
      final color = departmentColors[department] ?? Colors.grey;
      boxes.add(
        _statusBox(
          department,
          color,
          employees,
          context,
        ),
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing = 12;
        double boxWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: boxes.map((box) {
            return SizedBox(
              width: boxWidth,
              child: box,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _statusBox(String title, Color borderColor, List<Employee> employees, BuildContext context) {
    int visibleCount = 4;
    bool showExtra = employees.length > visibleCount;
    List<Employee> visibleEmployees = showExtra ? employees.sublist(0, visibleCount) : employees;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClockInScreen(employees: employees, title: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title (${employees.length})",
              style: FontStyles.subHeadingStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            AppSpacing.small(context),
            Wrap(
              spacing: 8,
              children: [
                ...visibleEmployees.map((e) => CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(e.avatarUrl),
                )),
                if (showExtra)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      "+${employees.length - visibleCount}",
                      style: FontStyles.subTextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}