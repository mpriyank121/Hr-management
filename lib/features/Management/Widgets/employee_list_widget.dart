import 'package:flutter/material.dart';

import '../../../config/app_text_styles.dart';
import '../../Employees/models/employee_model.dart';
import '../model/employee_model.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeListWidget({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(employee.avatarUrl),
          ),
          title:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style:  TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  employee.position,
                  style: AppTextStyles.subText)

            ],),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
          onTap: () {
            // Add action on tap if needed
          },
        );
      },
    );
  }
}
