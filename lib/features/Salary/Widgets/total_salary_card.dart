import 'package:flutter/material.dart';
import '../../../config/font_style.dart';
import '../../../config/style.dart';
import '../salary_history_screen.dart';

class TotalSalaryCard extends StatelessWidget {
  final String totalSalary;
  final VoidCallback onHistoryTap;

  const TotalSalaryCard({
    Key? key,
    required this.totalSalary,
    required this.onHistoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CustomPaint(
        painter: TripleOrangeWavePainter(),
        child: Container(
          width: screenWidth * 0.95,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Employee Salary Amount",
                style: FontStyles.subTextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                totalSalary,
                style: FontStyles.headingStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalaryHistoryScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.history),
                label: Text(
                  "History",
                  style: FontStyles.subHeadingStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}