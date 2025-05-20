import 'package:flutter/material.dart';
import '../../Add_depart_and_employee/new_employee_form.dart';
import '../../Attendence/attendence_screen.dart';
import '../../Management/Widgets/department_widget.dart';
import '../../employee_salary/employee_salary_screen.dart';
import '../dummy_data.dart';

class DepartmentEmployeeList extends StatelessWidget {
  final bool showEditButton;
  final Widget Function()? onTapRoute;


  const DepartmentEmployeeList({
    Key? key,
    this.showEditButton = false,
    this.onTapRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final departmentMap = DummyData.departmentWiseEmployees;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: departmentMap.length,
      itemBuilder: (context, index) {
        final department = departmentMap.keys.elementAt(index);
        final employees = departmentMap[department]!;

        return DepartmentWidget(
          title: department,
          child: Column(
            children: employees.map((employee) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(employee.avatarUrl),
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => onTapRoute != null
                            ? onTapRoute!()
                            : AttendancePage(title: ''),
                      ),
                    );
                  },
                  child: Text(
                    employee.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: showEditButton
                    ? IconButton(
                  icon: Image.asset("assets/images/edit_button.png",height: 24,width: 24,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewEmployeeForm()),
                    );
                  },
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text("${employee.hours} hr")],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
