import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../Assets/assets_screen.dart';
import '../Assets/models/asset_list_model.dart';
import '../Salary/Widgets/salary_history_list.dart';
import '../Salary/model/salary_model.dart';


class EmployeeSalaryScreen extends StatefulWidget {
  const EmployeeSalaryScreen({super.key, required this.title});
  final String title;

  @override
  State<EmployeeSalaryScreen> createState() => _EmployeeSalaryScreenState();
}

class _EmployeeSalaryScreenState extends State<EmployeeSalaryScreen> {
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
        title: "Salary",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            const SizedBox(height: 8),
            Text("Company Logo", style: FontStyles.subHeadingStyle(fontSize: 16)),

            AppSpacing.small(context),

            CustomTabWidget(
              tabTitles: ["Salary", "Assets"],
              controller: tabController,
            ),

            AppSpacing.small(context),

            Obx(() {
              final index = tabController.selectedIndex.value;

              return Column(
                children: [
                  if (index == 0)
                    SalaryHistoryList(salaryHistory: salaryHistory)
                  else
                    AssetsList(assetHistory: assetHistory),
                ],
              );
            }),

            AppSpacing.small(context),
          ],
        ),
      ),
    );
  }
}
