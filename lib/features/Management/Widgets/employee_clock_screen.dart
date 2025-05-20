import 'package:flutter/material.dart';
import '../../../core/widgets/App_bar.dart';
import '../model/employee_model.dart';
import 'employee_list_widget.dart';

class ClockInScreen extends StatelessWidget {
  final List<Employee> employees;
  final String title;

  const ClockInScreen({super.key, required this.employees, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: (title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EmployeeListWidget(employees: employees),
      ),
    );
  }
}
