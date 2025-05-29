import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_text_styles.dart';
import '../../Attendence/attendence_screen.dart';
import '../../Add_depart_and_employee/new_employee_form.dart';
import '../../Management/Widgets/department_widget.dart';
import '../controllers/employee_controller.dart';


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
    final EmployeeController controller = Get.find<EmployeeController>();

    return Obx(() {
      final departmentMap = controller.departmentWiseEmployees;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      employee.name,
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                      Text(
                        employee.position,
                        style: AppTextStyles.subText)

                    ],)
                  ),
                  trailing: showEditButton
                      ? IconButton(
                    icon: Image.asset(
                      "assets/images/edit_button.png",
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewEmployeeForm(),
                        ),
                      );
                    },
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Text(" hr")],
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }
}
