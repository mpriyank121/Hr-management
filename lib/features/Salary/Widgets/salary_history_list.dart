// widgets/salary_history_list.dart
import 'package:flutter/material.dart';
import '../../../config/font_style.dart';
import '../model/salary_model.dart';
import '../salary_summary_screen.dart';

class SalaryHistoryList extends StatelessWidget {
  final List<SalaryHistoryModel> salaryHistory;

  const SalaryHistoryList({super.key, required this.salaryHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: salaryHistory.length,
      shrinkWrap: true, // ✅ Allow ListView inside a scrollable parent
      physics: NeverScrollableScrollPhysics(), // ✅ Disable inner scroll
      itemBuilder: (context, index) {
        final item = salaryHistory[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/rupee_icon.png", fit: BoxFit.contain),
          ),
          title: Text(
            item.title,
            style: FontStyles.subHeadingStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Paid at ${item.dateTime}",
            style: FontStyles.subTextStyle(),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalarySummaryScreen(
                  grossPay: 10000,
                  taxes: 2000,
                  expenses: 2000,
                  paymentDate: DateTime(2023, 12, 31),
                  status: "Success",
                ),
              ),
            );
          },
        );
      },
    );
  }
}
