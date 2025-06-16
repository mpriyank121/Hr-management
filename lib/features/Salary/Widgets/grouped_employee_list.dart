// grouped_employee_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/font_style.dart';
import '../../Employees/controllers/employee_controller.dart';
import '../../Employees/models/employee_model.dart';

class GroupedEmployeeList extends StatelessWidget {
  final Function(Employee)? onTap;

  const GroupedEmployeeList({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.find<EmployeeController>();

    return Obx(() {
      final departmentMap = controller.departmentWiseEmployees;

      return Expanded(
        child: ListView.builder(
          itemCount: departmentMap.length,
          itemBuilder: (context, sectionIndex) {
            String department = departmentMap.keys.elementAt(sectionIndex);
            List<Employee> employees = departmentMap[department]!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        department,
                        style: FontStyles.subTextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEEEEEE),
                        ),
                      ),
                    ],
                  ),
                  ...employees.map((employee) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(employee.avatarUrl),
                      ),
                      title: Text(
                        employee.name,
                        style: FontStyles.subHeadingStyle(),
                      ),
                      subtitle: Text(
                        employee.position,
                        style: FontStyles.subTextStyle(),
                      ),
                      trailing: Text(
                        '₹8,050', // You might want to add salary to the Employee model
                        style: FontStyles.subHeadingStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (onTap != null) {
                          onTap!(employee);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
