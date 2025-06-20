import 'package:flutter/material.dart';
import 'package:hr_management/config/style.dart';
import '../model/clock_in_model.dart';
import '../../Management/Widgets/employee_clock_screen.dart';

class AttendanceStatusSection extends StatelessWidget {
  final List<ClockInModel> checkIn;
  final List<ClockInModel> notCheckIn;
  final List<ClockInModel> onLeave;

  const AttendanceStatusSection({
    Key? key,
    required this.checkIn,
    required this.notCheckIn,
    required this.onLeave
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 12;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boxWidth = (constraints.maxWidth - spacing) / 2;
        final double boxHeight = MediaQuery.of(context).size.height * 0.16;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: boxWidth,
              height: boxHeight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClockInScreen(
                        employees: checkIn,
                        title: 'Check-In',
                      ),
                    ),
                  );
                },
                child: _statusBox(
                  context,
                  title: 'Check-In',
                  color: Colors.green,
                  list: checkIn,
                ),
              ),
            ),
            SizedBox(
              width: boxWidth,
              height: boxHeight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClockInScreen(
                        employees: notCheckIn,
                        title: 'Not Check-In',
                      ),
                    ),
                  );
                },
                child: _statusBox(
                  context,
                  title: 'Not Check-In',
                  color: Colors.blue,
                  list: notCheckIn,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClockInScreen(
                        employees: onLeave,
                        title: 'On Leave',
                      ),
                    ),
                  );
                },
                child: _statusBox(
                  context,
                  title: 'On Leave',
                  color: Colors.red,
                  list: onLeave,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statusBox(
    BuildContext context, {
    required String title,
    required Color color,
    required List<ClockInModel> list,
  }) {
    const int visibleCount = 4;
    final bool showExtra = list.length > visibleCount;
    final List<ClockInModel> visibleEmployees =
        showExtra ? list.sublist(0, visibleCount) : list;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text("$title",style: fontStyles.headingStyle),
            Text(
              " (${list.length})",
            ),
          ],),

          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...visibleEmployees.map(
                    (a) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (a.profileUrl != null && a.profileUrl!.isNotEmpty)
                      ? NetworkImage("https://img.bookchor.com/${a.profileUrl}")
                      : null,
                  child: (a.profileUrl == null || a.profileUrl!.isEmpty)
                      ? Text(
                    a.empName.isNotEmpty ? a.empName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  )
                      : null,
                ),
              ),
              if (showExtra)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    "+${list.length - visibleCount}",
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 