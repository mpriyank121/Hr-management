import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Pie_chart.dart';
import '../../core/widgets/floating_action_button.dart';
import '../Add_depart_and_employee/department_form.dart';
import '../Add_depart_and_employee/new_employee_form.dart';
import '../Management/Widgets/bordered_container.dart';
import '../Management/Widgets/employee_clock_screen.dart';
import '../Management/model/employee_model.dart';
import 'Widgets/department_employee_list.dart';
import 'controllers/employee_controller.dart';
import 'employee_detail.dart';
import 'models/employee_model.dart';

class EmployeesScreen extends StatelessWidget {
  EmployeesScreen({Key? key}) : super(key: key);

  final EmployeeController controller = Get.put(EmployeeController());

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
      default:
        return 'Unknown';
    }
  }


  void _handleMenuSelection(String value) {
    if (value == 'department') {
      Get.to(() => AddNewDepartmentScreen(phone: ''));
    } else if (value == 'employee') {
      Get.to(() => NewEmployeeForm());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            // Implement back or drawer logic if needed
          },
        ),
        title: 'Employees',
        showTrailing: true,
      ),
      body: AppMargin(
        child: Obx(() {
          // Using Obx to reactively update UI on data changes
          final allEmployees = controller.employeeList;

          Map<String, double> statusCount = {};
          for (var status in EmploymentStatus.values) {
            final count = allEmployees.where((e) => e.employmentStatus == status).length;
            if (count > 0) {
              statusCount[_statusToString(status)] = count.toDouble();
            }
          }

          return ListView(
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
              BorderedContainer(
                child: DepartmentEmployeeList(
                  showEditButton: true,
                  onTapRoute: () => EmployeeDetail(title: ''),
                ),
              ),
              AppSpacing.small(context),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButtonWithMenu(
        onMenuItemSelected: _handleMenuSelection,
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final departmentMap = controller.departmentWiseEmployees;

    final Map<String, Color> departmentColors = {
      'Technical': const Color(0xFF1A96F0),
      'Marketing': const Color(0xFFF54336),
      'UI/UX': const Color(0xFF4CAF50),
    };

    final boxes = <Widget>[];

    departmentMap.forEach((department, employees) {
      final color = departmentColors[department] ?? Colors.grey;
      boxes.add(
        _statusBox(
          department,
          color,
          employees.cast<Employee>(),
          context,
        ),
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 12;
        final double boxWidth = (constraints.maxWidth - spacing) / 2;

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
  Widget _statusBox(
      String title,
      Color borderColor,
      List<Employee> employees,
      BuildContext context,
      ) {
    const int visibleCount = 4;
    final bool showExtra = employees.length > visibleCount;
    final List<Employee> visibleEmployees =
    showExtra ? employees.sublist(0, visibleCount) : employees;

    return GestureDetector(
      onTap: () {
        Get.to(() => ClockInScreen(employees: employees, title: title));
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
              style: FontStyles.subHeadingStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.small(context),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...visibleEmployees.map((e) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: e.avatarUrl.isNotEmpty
                      ? NetworkImage(e.avatarUrl)
                      : null,
                  child: e.avatarUrl.isEmpty
                      ? Text(
                    e.name.isNotEmpty
                        ? e.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                      : null,
                )),
                if (showExtra)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      "+${employees.length - visibleCount}",
                      style: FontStyles.subTextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
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
