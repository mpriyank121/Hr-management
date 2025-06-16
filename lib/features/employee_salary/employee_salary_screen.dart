import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../Salary/Widgets/salary_history_list.dart';
import '../Salary/model/salary_model.dart';
import '../Salary/controllers/salary_structure_controller.dart';
import '../Salary/models/salary_structure_model.dart';

class EmployeeSalaryScreen extends StatefulWidget {
  const EmployeeSalaryScreen({
    super.key, 
    required this.title,
    required this.employeeCode,
  });
  final String title;
  final String employeeCode;

  @override
  State<EmployeeSalaryScreen> createState() => _EmployeeSalaryScreenState();
}

class _EmployeeSalaryScreenState extends State<EmployeeSalaryScreen> {
  final TabControllerX tabController = Get.put(TabControllerX());
  final SalaryStructureController salaryController = Get.put(SalaryStructureController());
  final Rx<SalaryStructureModel?> salaryStructure = Rx<SalaryStructureModel?>(null);

  @override
  void initState() {
    super.initState();
    _fetchEmployeeSalary();
  }

  Future<void> _fetchEmployeeSalary() async {
    await salaryController.fetchEmployeeSalary(widget.employeeCode);
  }

  Widget _buildSalaryStructure() {
    return Obx(() {
      if (salaryController.isLoadingSalary.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (salaryController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            salaryController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      final salary = salaryController.employeeSalaryStructure.value;
      if (salary == null) {
        return const Center(
          child: Text('No salary details found'),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            _buildSalaryRow("CTC(Cost To Company)", salary.ctc),
            const SizedBox(height: 12),
            _buildSalaryRow("Base Salary", salary.basicSalary),
            const SizedBox(height: 12),
            _buildSalaryRow("HRA", salary.hra),
            const SizedBox(height: 12),
            _buildSalaryRow("Other Allowances", salary.otherAllowances ?? 0),
            const SizedBox(height: 12),
            _buildSalaryRow("PF", salary.pf),
            const SizedBox(height: 12),
            _buildSalaryRow("ESI", salary.esi),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.grey),
            ),
            _buildSalaryRow("Total Deductions", salary.totalDeductions),
            const SizedBox(height: 12),
            _buildSalaryRow("Net Salary", salary.netSalary),
          ],
        ),
      );
    });
  }

  Widget _buildSalaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

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
            CircleAvatar(
              radius: 40,
              child: Text(
                widget.title[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.title, style: FontStyles.subHeadingStyle(fontSize: 16)),

            AppSpacing.small(context),

            CustomTabWidget(
              tabTitles: ["Salary Structure", "History"],
              controller: tabController,
            ),

            AppSpacing.small(context),

            Obx(() {
              final index = tabController.selectedIndex.value;

              return Column(
                children: [
                  if (index == 0)
                    _buildSalaryStructure()
                  else
                    SalaryHistoryList(salaryHistory: const [])
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
