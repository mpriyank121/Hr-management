import 'package:flutter/material.dart';

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
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(

          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(employee.avatarUrl),
          ),
          title: Text(
            employee.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(''),
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
