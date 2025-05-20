import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../employee_salary/employee_salary_screen.dart';
import 'Widgets/grouped_employee_list.dart';
import 'Widgets/total_salary_card.dart';

class SalaryScreen extends StatefulWidget {
  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  DateTime selectedDate = DateTime.now();

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

  final Map<String, List<Map<String, String>>> groupedEmployees = {
    "Product": [
      {
        "name": "William Brown",
        "role": "Product Engineer",
        "salary": "₹8,050",
        "image": "https://i.pravatar.cc/150?img=1"
      },
      {
        "name": "Elizabeth Turner",
        "role": "Engineering Manager",
        "salary": "₹8,050",
        "image": "https://i.pravatar.cc/150?img=2"
      },
      {
        "name": "Emma Brown",
        "role": "HR Manager",
        "salary": "₹8,050",
        "image": "https://i.pravatar.cc/150?img=3"
      },
    ],
    "Engineering": [
      {
        "name": "Mia Rodriguez",
        "role": "HR Assistant",
        "salary": "₹8,050",
        "image": "https://i.pravatar.cc/150?img=4"
      },
      {
        "name": "Oliver Green",
        "role": "HR Coordinator",
        "salary": "₹8,050",
        "image": "https://i.pravatar.cc/150?img=5"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat('MMMM yyyy').format(selectedDate);

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),        title: 'Salary',
        showTrailing: true,

      ),
      body: AppMargin(child: Column(
        children: [
          AppSpacing.small(context),
          Container(decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFE6E6E6),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
            child:Center(
              child: TextButton.icon(
                onPressed: _pickMonth,
                icon: Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.black,  // Set icon color to black
                ),
                label: Text(
                  monthYear,
                  style: TextStyle(
                    color: Colors.black,  // Set text color to black
                  ),
                ),
              ),
            )

          ),
          AppSpacing.small(context),
          // Total Salary Card
          TotalSalaryCard(
            totalSalary: "₹ 1,00,000",
            onHistoryTap: () {

            },
          ),
          AppSpacing.small(context),
          // Employee List
          GroupedEmployeeList(
            groupedEmployees: groupedEmployees,
            onTap: (employee) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeSalaryScreen(title: '')),
              );
            },
          ),        ],
      )),
    );
  }
}
