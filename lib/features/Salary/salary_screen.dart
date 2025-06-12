import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hr_management/features/Salary/salary_structure_form.dart';
import 'package:intl/intl.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/floating_action_button.dart';
import '../Add_depart_and_employee/department_form.dart';
import '../Add_depart_and_employee/new_employee_form.dart';
import '../employee_salary/employee_salary_screen.dart';
import 'Widgets/grouped_employee_list.dart';
import 'Widgets/total_salary_card.dart';
import '../Employees/controllers/employee_controller.dart';

class SalaryScreen extends StatefulWidget {
  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  DateTime selectedDate = DateTime.now();
  final EmployeeController employeeController = Get.put(EmployeeController());

  void _pickMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Month',
      fieldHintText: 'Month/Year',
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleMenuSelection(String value) {
    if (value == 'department') {
      Get.to(() => AddNewDepartmentScreen(phone: ''));
    } else if (value == 'employee') {
      Get.to(() => SalaryStructureForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        title: 'Salary',
        showTrailing: true,
      ),
      body: AppMargin(
        child: Column(
          children: [
            AppSpacing.small(context),
            TotalSalaryCard(
              totalSalary: '',
              onHistoryTap: () {  },
            ),
            AppSpacing.small(context),
            GroupedEmployeeList(
              onTap: (employee) {
                Get.to(() => EmployeeSalaryScreen(title: employee.name));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButtonWithMenu(
        onMenuItemSelected: _handleMenuSelection,
      ),
    );
  }
}
