
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/workpattern_controller.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Leave_Container.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import 'controller/department_controller.dart';
import 'models/work_pattern_model.dart';

class AddNewDepartmentScreen extends StatefulWidget {
  final String phone;

  const AddNewDepartmentScreen({super.key, required this.phone});

  @override
  State<AddNewDepartmentScreen> createState() => _AddNewDepartmentScreenState();
}

class _AddNewDepartmentScreenState extends State<AddNewDepartmentScreen> {
  final DepartmentController controller = Get.put(DepartmentController());
  final WorkPatternController workPatternController = Get.put(WorkPatternController());

  @override
  void initState() {
    super.initState();
    workPatternController.fetchWorkPatterns(); // fetch patterns on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(color: Colors.black),
        title: 'Add New Department',
        centerTitle: true,
      ),
      body: AppMargin(
        child: Obx(() {
          if (controller.isLoading.value || workPatternController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.small(context),
              Text('Department Name', style: FontStyles.subHeadingStyle()),
              AppSpacing.small(context),
              CustomTextField(
                hint: 'Enter Department Name',
                controller: controller.departmentNameController,
              ),
              AppSpacing.small(context),
              Text('Work Pattern', style: FontStyles.subHeadingStyle()),
              AppSpacing.small(context),
              LeaveContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomDropdown<WorkPattern>(

                  value: workPatternController.selectedPattern.value,
                  items: workPatternController.workPatterns.map((pattern) {
                    return DropdownMenuItem<WorkPattern>(
                      value: pattern,
                      child: Text(pattern.workPattern),
                    );
                  }).toList(),
                  onChanged: (val) {
                    workPatternController.changeSelectedPattern(val);
                  },
                ),
              ),
              AppSpacing.small(context),
              Text('Supervisor', style: FontStyles.subHeadingStyle()),
              AppSpacing.small(context),
              CustomTextField(
                hint: 'Enter Supervisor Name',
                controller: controller.supervisorController,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      textColor: const Color(0xFFF25922),
                      buttonColor: const Color(0x19CD0909),
                      text: "Cancel",
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: "Save",
                      onPressed: () {
                        if (workPatternController.selectedPattern.value == null) {
                          Get.snackbar('Error', 'Please select a work pattern');
                          return;
                        }
                        controller.submitDepartment(
                          widget.phone,
                          workPatternController.selectedPattern.value!,

                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

