import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import 'models/employee_model.dart';
import 'controllers/employee_controller.dart';
import 'controllers/department_color_genrator.dart';
import '../Management/Widgets/employee_clock_screen.dart';

class EmployeeStatusSection extends StatelessWidget {
  const EmployeeStatusSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.find<EmployeeController>();
    final departmentMap = controller.departmentWiseEmployees;
    final boxes = <Widget>[];

    departmentMap.forEach((department, employees) {
      final color = DepartmentColorGenerator.getColorForDepartment(department);
      boxes.add(
        _statusBox(
          department,
          color,
          employees.cast<Employee>(),
          context,
        ),
      );
    });

    // Add unassigned employees as a separate box if any
    final unassigned = controller.unassignedEmployees;
    if (unassigned.isNotEmpty) {
      boxes.add(
        _statusBox(
          'Unassigned',
          Colors.grey, // Use a distinct color for unassigned
          unassigned,
          context,
        ),
      );
    }

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
        //Get.to(() => ClockInScreen(employees: employees, title: title));
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
                      "+{employees.length - visibleCount}",
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