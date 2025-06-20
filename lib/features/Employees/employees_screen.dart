import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/custom_expansion_tile.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Empty_state_widget.dart';
import '../../core/widgets/Pie_chart.dart';
import '../../core/widgets/floating_action_button.dart';
import '../Add_depart_and_employee/controller/department_type_controller.dart';
import '../Add_depart_and_employee/department_form.dart';
import '../Add_depart_and_employee/new_employee_form.dart';
import '../Management/Widgets/bordered_container.dart';
import 'Widgets/department_employee_list.dart';
import 'controllers/employee_controller.dart';
import 'employee_status_section.dart';
import 'models/employee_model.dart';
class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final EmployeeController controller = Get.put(EmployeeController());
  final DepartmentTypeController departmentController = Get.find<DepartmentTypeController>();

  @override
  void initState() {
    super.initState();
    controller.fetchEmployees();
    departmentController.fetchDepartments();
  }

  String _statusToString(EmploymentStatus status) {
    switch (status) {
      case EmploymentStatus.permanent:
        return 'Permanent';
      case EmploymentStatus.contract:
        return 'Contract';
      case EmploymentStatus.intern:
        return 'Intern';
      case EmploymentStatus.partTime:
        return 'Part-Time';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.pink.shade300,
      Colors.blue.shade300,
      Colors.orange.shade300,
      Colors.black87,
    ];

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {
            // back or drawer logic
          },
        ),
        title: 'Employees',
        showTrailing: true,
      ),
      body: AppMargin(
        child: Obx(() {
          final assigned = controller.assignedEmployees;
          final unassigned = controller.unassignedEmployees;
          if (assigned.isEmpty && unassigned.isEmpty) {
            return EmptyStateWidget(
              imagePath: 'assets/images/empty_employee.png',
              title: 'Empty',
              subtitle: "You haven't added departments and,\n employees yet.",
            );
          }

          Map<String, double> statusCount = {};
          for (var status in EmploymentStatus.values) {
            final count = assigned.where((e) => e.employmentStatus == status).length;
            if (count > 0) {
              statusCount[_statusToString(status)] = count.toDouble();
            }
          }

          return ListView(
            children: [
              AppSpacing.small(context),
              EmployeeStatusSection(),
              AppSpacing.small(context),
              CustomExpansionTile(
                  title: Text(
                    'Employee Status',
                    style: FontStyles.subHeadingStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  initiallyExpanded: true,
                  children: [
                    PieChartWidget(
                        dataMap: statusCount,
                        colorList: colors,
                        centerText: '${assigned.length}\nTotal Employees',
                        chartRadius: 150,
                        showLegend: true,
                        showChartValues: false,
                        centerTextStyle: FontStyles.subHeadingStyle(),
                        chartType: ChartType.ring,
                      ),

                  ],
                ),

              AppSpacing.small(context),
              BorderedContainer(
                child: DepartmentEmployeeList(
                  showEditButton: true,
                ),
              ),
              AppSpacing.small(context),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButtonWithMenu(
        onMenuItemSelected: (value) {
          switch (value) {
            case 'department':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewDepartmentScreen(phone: '',)),
              );
              break;
            case 'employee':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewEmployeeForm()),
              );
              break;
          }
        },
        menuItems: [
          MenuItem(icon: Icons.apartment, text: 'Department', value: 'department'),
          MenuItem(icon: Icons.person, text: 'Employee', value: 'employee'),
        ],
      ),
    );

  }
}
