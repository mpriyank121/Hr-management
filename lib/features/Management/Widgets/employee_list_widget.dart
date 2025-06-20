import 'package:flutter/material.dart';
import 'package:hr_management/config/style.dart';
import '../model/clock_in_model.dart';
import 'employee_clock_screen.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<ClockInModel> employees;
  final String title;

  const EmployeeListWidget({super.key, required this.employees, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: (employee.profileUrl != null && employee.profileUrl!.isNotEmpty)
                ? NetworkImage("https://img.bookchor.com/${employee.profileUrl}")
                : null,
            child: (employee.profileUrl == null || employee.profileUrl!.isEmpty)
                ? Text(
                    employee.empName.isNotEmpty ? employee.empName[0].toUpperCase() : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.empName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                employee.empCode,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: title == 'Check-In'
              ? Text(
                  employee.firstIn != null ? employee.firstIn! : '-',
                  style: fontStyles.subHeadingStyle,
                )
              : IconButton(
                  icon: Image.asset("assets/images/phone.png",height: 24,width: 24),
                  onPressed: () {
                    // Implement call action here
                  },
                ),
          onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClockInDetailScreen(
                     employee: employee,
                  ),
                ),
              );
            },

        );
      },
    );
  }
}
