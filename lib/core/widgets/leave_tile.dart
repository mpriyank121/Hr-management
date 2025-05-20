import 'package:flutter/material.dart';

import '../../features/Attendence/Models/leave_model.dart';


class LeaveListWidget extends StatelessWidget {
  final List<LeaveModel> leaveList;

  const LeaveListWidget({super.key, required this.leaveList});

  @override
  Widget build(BuildContext context) {
    if (leaveList.isEmpty) {
      return const Center(
        child: Text("No leaves found"),
      );
    }

    return Column(
      children: leaveList.map((leave) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    leave.leaveName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${leave.startDate} - ${leave.endDate}"),
                ),
                const Divider(height: 1),

              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
