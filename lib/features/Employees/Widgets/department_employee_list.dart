import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/Employees/employee_detail.dart';
import '../../../config/app_text_styles.dart';
import '../../Add_depart_and_employee/controller/department_type_controller.dart';
import '../../Add_depart_and_employee/department_form.dart';
import '../../Attendence/attendence_screen.dart';
import '../../Add_depart_and_employee/new_employee_form.dart';
import '../../Management/Widgets/department_widget.dart';
import '../controllers/employee_controller.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';


class DepartmentEmployeeList extends StatelessWidget {
  final bool showEditButton;
  final Widget Function()? onTapRoute;
  final String? empId;

  const DepartmentEmployeeList({
    Key? key,
    this.showEditButton = false,
    this.onTapRoute,
    this.empId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.find<EmployeeController>();
    final DepartmentTypeController departmentController = Get.find<DepartmentTypeController>();

    return Obx(() {
      final departmentMap = controller.departmentWiseEmployees;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: departmentMap.length,
        itemBuilder: (context, index) {
          final department = departmentMap.keys.elementAt(index);
          final employees = departmentMap[department]!;
          final departmentModel = departmentController.departmentList.firstWhereOrNull(
            (dept) => dept.department == department
          );

          return DepartmentWidget(
            title: department,
            departmentId: departmentModel?.id,
            onEdit: showEditButton ? () {
              print('Edit button pressed for department: $department');
              if (departmentModel != null) {
                print('Opening edit screen for department: ${departmentModel.department}');
                Get.to(() => AddNewDepartmentScreen(
                  phone: '9311289522',
                  department: departmentModel,
                ));
              } else {
                print('Department model is null');
                CustomToast.showMessage(
                  context: context,
                  title: 'Error',
                  message: 'Could not find department details. Please try again.',
                  isError: true,
                );
              }
            } : null,
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
                              : EmployeeDetail(employee: employee),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          employee.position,
                          style: AppTextStyles.subText
                        )
                      ],
                    )
                  ),
                  trailing: showEditButton
                      ? IconButton(
                          icon: Image.asset(
                            "assets/images/edit_button.png",
                            height: 24,
                            width: 24,
                          ),
                          onPressed: () {
                            print('Edit button pressed for employee: ${employee.name}');
                            Get.to(() => NewEmployeeForm(
                              empId: employee.id,
                            ));
                          },
                        )
                      : null,
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }
}
