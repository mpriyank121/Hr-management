import 'package:flutter/material.dart';
import '../../config/App_margin.dart';
import '../../core/widgets/App_bar.dart';
import 'Widgets/salary_history_list.dart';
import 'model/salary_model.dart';


class SalaryHistoryScreen extends StatelessWidget {
  SalaryHistoryScreen({super.key});

  final List<SalaryHistoryModel> salaryHistory = List.generate(
    10,
        (index) => SalaryHistoryModel(
      title: "Payroll - ₹25,000",
      amount: "₹25,000",
      dateTime: "09:40, 31 December",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Salary History",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Optional: search functionality
            },
          ),
        ],
      ),
      body:AppMargin(child: SalaryHistoryList(salaryHistory: salaryHistory)) ,
    );
  }
}
