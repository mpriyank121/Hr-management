import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import 'Widgets/grouped_employee_list.dart';

class SalarySummaryScreen extends StatelessWidget {
  final double grossPay;
  final double taxes;
  final double expenses;
  final DateTime paymentDate;
  final String status;

  const SalarySummaryScreen({
    super.key,
    required this.grossPay,
    required this.taxes,
    required this.expenses,
    required this.paymentDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final totalPayroll = grossPay - taxes - expenses;
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

    return Scaffold(
      appBar: CustomAppBar(
        title: "Salary Summary",
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset('assets/images/download-01.png', fit: BoxFit.contain),
            onPressed: () {
              // Handle download
            },
          ),
        ],
      ),
      body: AppMargin(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payroll Summary",
                style: FontStyles.subTextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              AppSpacing.small(context),
              _buildRow("Subtotal Gross pay", grossPay),
              _buildRow("Subtotal taxes", -taxes),
              _buildRow("Expenses", -expenses),
              Divider(height: 32),
              _buildRow("Total Payroll", totalPayroll, isBold: true),
              AppSpacing.small(context),
              _buildInfoRow("Payment Date", DateFormat.yMMMMd().format(paymentDate)),
              AppSpacing.small(context),
              _buildStatusRow("Status", status),
              AppSpacing.small(context),
              GroupedEmployeeList(
                groupedEmployees: groupedEmployees,
                onTap: (employee) {
                  // handle tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: FontStyles.subTextStyle()),
          Text(
            "₹ ${value.toStringAsFixed(2)}",
            style: FontStyles.subTextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: value < 0 ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: FontStyles.subTextStyle()),
        Text(value, style: FontStyles.subTextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusRow(String title, String value) {
    final isSuccess = value.toLowerCase() == "success";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: FontStyles.subTextStyle()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: FontStyles.subHeadingStyle(
              color: isSuccess ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}