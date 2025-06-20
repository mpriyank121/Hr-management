import 'package:flutter/material.dart';
import '../../config/font_style.dart';
import '../../features/Employees/models/employee_model.dart';



class DepartmentStatusBox extends StatelessWidget {
  final String title;
  final Color borderColor;
  final List<Employee> employees;

  const DepartmentStatusBox({
    Key? key,
    required this.title,
    required this.borderColor,
    required this.employees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int visibleCount = 4;
    bool showExtra = employees.length > visibleCount;
    List<Employee> visibleEmployees = showExtra ? employees.sublist(0, visibleCount) : employees;

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ClockInScreen(employees: employees, title: title),
        //   ),
        // );
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
              style: FontStyles.subHeadingStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ...visibleEmployees.map((e) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(e.avatarUrl),
                  );
                }).toList(),
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
