import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/style.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/new_employee_model.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Custom_tab_widget.dart';
import '../../core/widgets/Leave_Container.dart';
import '../Assets/assets_screen.dart';
import '../Assets/models/asset_list_model.dart';
import '../Salary/Widgets/salary_history_list.dart';
import '../Salary/model/salary_model.dart';
import 'models/employee_model.dart';

class EmployeeDetail extends StatefulWidget {
  final Employee employee;
  final String? empId;
  const EmployeeDetail({super.key, required this.employee, this.empId});

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
      body: AppMargin(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.small(context),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.employee.avatarUrl.isNotEmpty
                    ? NetworkImage(widget.employee.avatarUrl)
                    : null,
                child: widget.employee.avatarUrl.isEmpty
                    ? Text(
                  widget.employee.name[0].toUpperCase(),
                  style: FontStyles.headingStyle().copyWith(
                    fontSize: 32,
                    color: Colors.grey[600],
                  ),
                )
                    : null,
              ),

              const SizedBox(height: 8),
              Text(
                widget.employee.name,
                style: FontStyles.headingStyle(),
              ),
              Text(
                widget.employee.position,
                style: FontStyles.subHeadingStyle().copyWith(
                  color: Colors.grey[600],
                ),
              ),

              AppSpacing.small(context),

              CustomTabWidget(
                tabTitles: ["Details", "Assets", "Doc"],
                controller: tabController,
              ),

              AppSpacing.small(context),

              Obx(() {
                final index = tabController.selectedIndex.value;

                if (index == 0) {
                  return _buildEmployeeDetails();
                } else if (index == 1) {
                  return SalaryHistoryList(salaryHistory: salaryHistory);
                } else {
                  return AssetsList(assetHistory: assetHistory);
                }
              }),

              AppSpacing.small(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDetails() {
    return Column(
      children: [
        _buildInfoSection('Personal Information', [
          _buildInfoRow('Employee Code', widget.employee.empCode),
          _buildInfoRow('Gender', widget.employee.gender),
          _buildInfoRow('Phone', widget.employee.phone),
          _buildInfoRow('Email', widget.employee.email),
        ]),
        AppSpacing.small(Get.context!),
        _buildInfoSection('Employment Details', [
          _buildInfoRow('Department', widget.employee.department),
          _buildInfoRow('Position', widget.employee.position),
          _buildInfoRow('Job Type', widget.employee.empType),
          _buildInfoRow('Joining Date', widget.employee.doj),
          _buildInfoRow('Role', widget.employee.userRole),
        ]),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: fontStyles.headingStyle),
        AppSpacing.small(Get.context!),
        LeaveContainer(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: FontStyles.subHeadingStyle().copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: FontStyles.subHeadingStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
