import 'package:flutter/material.dart';
import '../../../config/app_buttons.dart';
import '../../../config/app_spacing.dart';
import '../../../config/font_style.dart';
import 'noti_icon.dart';

class WorkingDaysSelector extends StatefulWidget {
  const WorkingDaysSelector({Key? key}) : super(key: key);

  @override
  State<WorkingDaysSelector> createState() => _WorkingDaysSelectorState();
}

class _WorkingDaysSelectorState extends State<WorkingDaysSelector> {
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<bool> activeDays = [true, true, true, true, true, true, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Working days',
          style: FontStyles.subTextStyle(),
        ),
      AppSpacing.small(context),
        Row(
          children: List.generate(days.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: NotificationIconWidget(
                isActive: activeDays[index],
                onTap: () {
                  setState(() {
                    activeDays[index] = !activeDays[index];
                  });
                },
                child: Text(
                  days[index],
                  style: TextStyle(
                    color: activeDays[index] ? PrimaryButtonConfig.color : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
        ),
        AppSpacing.small(context),
        Divider(thickness: 1, color: Colors.grey.shade300),

      ],
    );
  }
}
