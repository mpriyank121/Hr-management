import 'package:flutter/material.dart';
import 'package:hr_management/features/Company_details/Company_details_screen.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../Management/management_screen.dart';
import 'Widgets/attendence_location_card.dart';
import 'Widgets/shift_time_picker.dart';
import 'Widgets/working_days_selector.dart';

class StaffAttendanceSettingsScreen extends StatelessWidget {
  const StaffAttendanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Staff Attendance Settings",),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShiftTimePicker(),
            AppSpacing.small(context),
            const WorkingDaysSelector(),
            AppSpacing.small(context),
            const AttendanceLocationCard(),
            AppSpacing.small(context),
            PrimaryButton(
              text: "Register Now",
              onPressed: () {
                Navigator.push(
                  context,
                   MaterialPageRoute(
                    builder: (context) =>CompanyDetailsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
