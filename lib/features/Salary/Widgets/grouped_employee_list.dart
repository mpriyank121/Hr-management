// grouped_employee_list.dart
import 'package:flutter/material.dart';

import '../../../config/font_style.dart';

class GroupedEmployeeList extends StatelessWidget {
  final Map<String, List<Map<String, String>>> groupedEmployees;
  final Function(Map<String, String>)? onTap;

  const GroupedEmployeeList({
    Key? key,
    required this.groupedEmployees,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: groupedEmployees.keys.length,
        itemBuilder: (context, sectionIndex) {
          String sectionTitle = groupedEmployees.keys.elementAt(sectionIndex);
          List<Map<String, String>> employees = groupedEmployees[sectionTitle]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      sectionTitle,
                      style: FontStyles.subTextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFEEEEEE),
                      ),
                    ),
                  ],
                ),

                ...employees.map((employee) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(employee['image']!),
                    ),
                    title: Text(
                      employee['name']!,
                      style: FontStyles.subHeadingStyle(),
                    ),
                    subtitle: Text(
                      employee['role']!,
                      style: FontStyles.subTextStyle(),
                    ),
                    trailing: Text(
                      employee['salary']!,
                      style: FontStyles.subHeadingStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      if (onTap != null) {
                        onTap!(employee);
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
