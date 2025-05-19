import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/Configuration/App_margin.dart';
import 'package:hr_management/Salary/Widgets/salary_history_list.dart';
import 'package:hr_management/Salary/model/salary_model.dart';

import '../Assets/assets_screen.dart';
import '../Assets/models/asset_list_model.dart';
import '../widgets/App_bar.dart';
import '../widgets/Custom_tab_widget.dart';
import '../Configuration/app_spacing.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({super.key, required this.title});
  final String title;

  @override
  State<EmployeeDetail> createState() => _EmployeeSalaryScreenState();
}

class _EmployeeSalaryScreenState extends State<EmployeeDetail> {
  final TabControllerX tabController = Get.put(TabControllerX());

  final List<SalaryHistoryModel> salaryHistory = List.generate(
    10,
        (index) => SalaryHistoryModel(
      title: "Payroll - ₹25,000",
      amount: "₹25,000",
      dateTime: "09:40, 31 December",
    ),
  );

  final List<AssetModel> assetHistory = [
    AssetModel(
      assetName: "Lenovo Laptop",
      assignedDate: "10 Jan 2025",
      iconPath: "assets/icons/laptop.png",
    ),
    AssetModel(
      assetName: "Samsung Phone",
      assignedDate: "03 Mar 2025",
      iconPath: "assets/icons/phone.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Employee Detail",
        showBackButton: true,
      ),
      body: AppMargin(child: SingleChildScrollView(
        child: Column(
          children: [
            AppSpacing.small(context),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            const SizedBox(height: 8),
            const Text("Company Logo", style: TextStyle(fontSize: 16)),

            AppSpacing.small(context),

            CustomTabWidget(
              tabTitles: ["Details", "Salary", "Doc"],
              controller: tabController,
            ),

            AppSpacing.small(context),

            Obx(() {
              final index = tabController.selectedIndex.value;

              return Column(
                children: [
                  if (index == 1)
                    SalaryHistoryList(salaryHistory: salaryHistory)
                  else
                    AssetsList(assetHistory: assetHistory),
                ],
              );
            }),

            AppSpacing.small(context),
          ],
        ),
      )),
    );
  }
}
