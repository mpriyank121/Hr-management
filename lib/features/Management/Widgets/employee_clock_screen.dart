import 'package:flutter/material.dart';
import 'package:hr_management/config/style.dart';
import 'package:hr_management/features/Management/Widgets/bordered_container.dart';
import '../../../core/widgets/App_bar.dart';
import '../model/clock_in_model.dart';
import 'employee_list_widget.dart';

class ClockInScreen extends StatelessWidget {
  final List<ClockInModel> employees;
  final String title;

  const ClockInScreen({super.key, required this.employees, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: (title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EmployeeListWidget(
          employees: employees,
          title: title,
        ),
      ),
    );
  }
}

class ClockInDetailScreen extends StatelessWidget {
  final ClockInModel employee; // Pass the entire model instead

  const ClockInDetailScreen({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
       title: "Check In",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date section
            Text(
              employee.date ?? '15 January, Monday',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            // Clock In and Clock Out cards
            Row(
              children: [
                // Clock In card
                Expanded(
                  child: _buildTimeCard(
                    title: 'Clock In',
                    time: employee.firstIn ?? '_',
                    isClockIn: true,
                  ),
                ),

                // "To" text in the middle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'To',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Clock Out card
                Expanded(
                  child: _buildTimeCard(
                    title: 'Clock Out',
                    time: employee.lastOut ?? '-',
                    isClockIn: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Total Hours section
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Total Hours : '),
                  // TextSpan(
                  //   text: _calculateTotalHours(),
                  //   style: const TextStyle(
                  //     color: Color(0xFF4CAF50), // Green color
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  const TextSpan(text: ' Hours'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String time,
    required bool isClockIn,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: fontStyles.subTextStyle
        ),
        BorderedContainer(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: time == '-' ? Colors.grey[400] : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}