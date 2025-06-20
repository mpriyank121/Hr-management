import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/app_spacing.dart';
import 'package:hr_management/config/font_style.dart';
import 'package:hr_management/config/style.dart';
import 'package:hr_management/features/Employees/employee_detail.dart';
import '../../../config/app_text_styles.dart';
import '../../Add_depart_and_employee/controller/department_type_controller.dart';
import '../../Add_depart_and_employee/department_form.dart';
import '../../Add_depart_and_employee/new_employee_form.dart';
import '../../Management/Widgets/department_widget.dart';
import '../controllers/employee_controller.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

class DepartmentEmployeeList extends StatelessWidget {
  final bool showEditButton;
  final Widget Function(String)? onTapRoute;
  final String? empId;

  const DepartmentEmployeeList({
    Key? key,
    this.showEditButton = false,
    this.onTapRoute,
    this.empId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.find<EmployeeController>();
    final DepartmentTypeController departmentController = Get.find<DepartmentTypeController>();

    return Obx(() {
      final departmentMap = controller.departmentWiseEmployees;
      final unassigned = controller.unassignedEmployees;

      final departmentWidgets = List<Widget>.generate(departmentMap.length, (index) {
        final department = departmentMap.keys.elementAt(index);
        final employees = departmentMap[department]!;
        final departmentModel = departmentController.departmentList.firstWhereOrNull(
              (dept) => dept.department == department,
        );

        return DepartmentWidget(
          title: department,
          departmentId: departmentModel?.id,
          onEdit: showEditButton
              ? () {
            if (departmentModel != null) {
              Get.to(() => AddNewDepartmentScreen(
                phone: '',
                department: departmentModel,
              ));
            } else {
              CustomToast.showMessage(
                context: context,
                title: 'Error',
                message: 'Could not find department details. Please try again.',
                isError: true,
              );
            }
          }
              : null,
          child: Column(
              children: employees.map((employee) {
                return  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(employee.avatarUrl),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => onTapRoute != null
                                    ? onTapRoute!(employee.id)
                                    : EmployeeDetail(employee: employee),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                  employee.name,
                                  style: fontStyles.headingStyle,
                                ),
                                SizedBox(width: 4,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    employee.empCode,
                                    style: FontStyles.subHeadingStyle(fontSize: 10,color: Colors.white),
                                  ),
                                ),

                                Spacer(),
                                if (!showEditButton)
                                  Text(
                                    "${employee.workingHours ?? ''} hrs",
                                    style: FontStyles.subTextStyle(color: Colors.green),
                                  ),

                              ]),

                              Text(employee.position, style: AppTextStyles.subText),
                              AppSpacing.small(context)
                            ],
                          ),
                        ),
                      ),
                      if (showEditButton)
                        IconButton(
                          icon: Image.asset(
                            "assets/images/edit_button.png",
                            height: 20,
                            width: 20,
                          ),
                          onPressed: () {
                            Get.to(() => NewEmployeeForm(empId: employee.id));
                          },
                        ),
                    ],
                  );

              }).toList(),
            ));

      });

      // Add unassigned employees in a bordered container
      if (unassigned.isNotEmpty) {
        departmentWidgets.add(
          DepartmentWidget(
            title: 'Unassigned',
            departmentId: null,
            onEdit: null,
            child: Column(
                children: unassigned.map((employee) {
                  return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(employee.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => onTapRoute != null
                                      ? onTapRoute!(employee.id)
                                      : EmployeeDetail(employee: employee),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(employee.position, style: AppTextStyles.subText),
                              ],
                            ),
                          ),
                        ),
                        if (showEditButton)
                          IconButton(
                            icon: Image.asset(
                              "assets/images/edit_button.png",
                              height: 20,
                              width: 20,
                            ),
                            onPressed: () {
                              Get.to(() => NewEmployeeForm(empId: employee.id));
                            },
                          ),
                      ],
                    );

                }).toList(),
              ),

          ),
        );
      }
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: departmentWidgets,
      );
    });
  }
}
