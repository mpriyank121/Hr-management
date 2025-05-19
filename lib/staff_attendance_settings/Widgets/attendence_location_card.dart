import 'package:flutter/material.dart';
import 'package:hr_management/Configuration/app_spacing.dart';
import 'package:hr_management/staff_attendance_settings/Widgets/custom_container.dart';
import 'package:hr_management/widgets/primary_button.dart';
import '../../Configuration/app_buttons.dart';
import '../../Configuration/font_style.dart';

class AttendanceLocationCard extends StatefulWidget {
  const AttendanceLocationCard({super.key});

  @override
  State<AttendanceLocationCard> createState() =>
      _AttendanceLocationCardState();
}

class _AttendanceLocationCardState extends State<AttendanceLocationCard> {
  String selectedOption = "From Office";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x19F25822), // light orange background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Attendance Location',
            style: FontStyles.subHeadingStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
           Text(
            'Staff can make attendance within this radius only',
             style: FontStyles.subTextStyle(),
          ),
          AppSpacing.small(context),
          // Radio Options
          Column(
            children: [
              _buildRadioTile('From office'),
              AppSpacing.small(context),
              _buildRadioTile('From Anywhere'),
            ],
          ),
          AppSpacing.small(context),
          // Location Details
          CustomContainer(
            child: Row(
              children: [
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Align to top
                    children: [
                      Text('Bookchor', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('RDC Ghaziabad', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.07,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: PrimaryButtonConfig.color,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to top
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children:  [
                      AppSpacing.small(context), // Optional small spacing from top
                      Text(
                        '100 m\nAllowed Range',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRadioTile(String title) {
    final isSelected = selectedOption == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = title;
        });
      },
      child: CustomContainer(
        isSelected: isSelected,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFF25822) : Colors.grey,
            ),
            AppSpacing.small(context),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFFF25822) : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
