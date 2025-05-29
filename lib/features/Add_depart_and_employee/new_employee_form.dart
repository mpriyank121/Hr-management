import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/job_type_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/job_type_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/Leave_Container.dart';
import '../../core/widgets/primary_button.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import '../Company_details/Widgets/section_title.dart';
import '../Company_details/Widgets/upload_card.dart';
import 'controller/department_type_controller.dart';
import 'controller/position_controller.dart';
import 'controller/new_employee_controller.dart';
import 'models/department_type_model.dart';
import 'models/new_employee_model.dart';
import 'models/position_model.dart';
import 'package:intl/intl.dart';

class NewEmployeeForm extends StatefulWidget {
  const NewEmployeeForm({super.key});

  @override
  _NewEmployeeFormState createState() => _NewEmployeeFormState();
}

class _NewEmployeeFormState extends State<NewEmployeeForm> {
  final JobTypeController controller = Get.put(JobTypeController());
  final PositionController positionController = Get.put(PositionController());
  final DepartmentTypeController departmentController = Get.put(DepartmentTypeController());
  final NewEmployeeController employeeController = Get.put(NewEmployeeController());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final startDateController = TextEditingController();

  final RxString selectedGender = ''.obs;

  File? panImage;
  File? profileImage;


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (nameController.text.isEmpty ||
        startDateController.text.isEmpty||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedGender.value.isEmpty ||
        departmentController.selectedDepartment.value == null ||
        controller.selectedJobType.value == null ||
        positionController.selectedPosition.value == null) {
      Get.snackbar("Error", "Please fill all required fields.");
      return;
    }

    final newEmployee = NewEmployeeModel(
      empName: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      departmentId: departmentController.selectedDepartment.value!.id,
      gender: selectedGender.value,
      positionId: positionController.selectedPosition.value!.id,
      website: websiteController.text,
      empTypeId: controller.selectedJobType.value!.id,
      panFilePath: panImage?.path,
      date: startDateController.text,
      profilePath: profileImage?.path,
    );

    employeeController.submitNewEmployee(newEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add New Employee", leading: const BackButton()),
      body: AppMargin(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.small(context),
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : const AssetImage('assets/logo.png') as ImageProvider,
              ),
              TextButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      profileImage = File(picked.path);
                    });
                  }
                },
                child: const Text("Upload Profile Picture"),
              ),

              AppSpacing.small(context),
              const SectionTitle(title: "Full Name"),
              AppSpacing.small(context),
              CustomTextField(hint: "Employee Name", controller: nameController),
              AppSpacing.small(context),
              const SectionTitle(title: "Position"),
              AppSpacing.small(context),
              LeaveContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Obx(() {
                  return DropdownButton<Position>(
                    value: positionController.selectedPosition.value,
                    hint: const Text('Select Position'),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: positionController.positions.map((position) {
                      return DropdownMenuItem<Position>(
                        value: position,
                        child: Text(position.position),
                      );
                    }).toList(),
                    onChanged: (val) => positionController.selectPosition(val),
                  );
                }),
              ),
              AppSpacing.small(context),
              const SectionTitle(title: "Employment Type"),
              Obx(() {
                return LeaveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<JobType>(
                    value: controller.selectedJobType.value,
                    hint: const Text('Select Job Type'),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: controller.jobTypes.map((jobType) {
                      return DropdownMenuItem<JobType>(
                        value: jobType,
                        child: Text(jobType.type),
                      );
                    }).toList(),
                    onChanged: (val) => controller.selectJobType(val),
                  ),
                );
              }),
              AppSpacing.small(context),
              const SectionTitle(title: "Department"),
              AppSpacing.small(context),
              Obx(() {
                if (departmentController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (departmentController.errorMessage.isNotEmpty) {
                  return Text("Error: ${departmentController.errorMessage.value}");
                } else {
                  return LeaveContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<DepartmentModel>(
                      value: departmentController.selectedDepartment.value,
                      hint: const Text('Select Department'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: departmentController.departmentList.map((department) {
                        return DropdownMenuItem<DepartmentModel>(
                          value: department,
                          child: Text(department.department),
                        );
                      }).toList(),
                      onChanged: (val) => departmentController.selectDepartment(val),
                    ),
                  );
                }
              }),
              AppSpacing.small(context),
              const SectionTitle(title: "Gender"),
              AppSpacing.small(context),
              LeaveContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Obx(() => DropdownButton<String>(
                  value: selectedGender.value.isEmpty ? null : selectedGender.value,
                  hint: const Text("Select Gender"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ["Male", "Female", "Other"].map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedGender.value = val;
                  },
                )),
              ),
              AppSpacing.small(context),
              const SectionTitle(title: "Phonenumber"),
              AppSpacing.small(context),
              CustomTextField(hint: "Enter Number", controller: phoneController, keyboardType: TextInputType.number),
              AppSpacing.small(context),
              const SectionTitle(title: "Email*"),
              AppSpacing.small(context),
              CustomTextField(hint: "example@gmail.com", controller: emailController),
              AppSpacing.small(context),
              const SectionTitle(title: "Website"),
              AppSpacing.small(context),
              CustomTextField(hint: "www.example.com", controller: websiteController),
              AppSpacing.small(context),
              const SectionTitle(title: "Employee Identification Document"),
              AppSpacing.small(context),
              UploadCard(
                title: "Upload your PAN card",
                onImageSelected: (file) => panImage = file,
              ),
              AppSpacing.small(context),
              const SectionTitle(title: "Start Date of Employment"),
              AppSpacing.small(context),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
                    startDateController.text = formattedDate;
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    hint: "Start Date",
                    controller: startDateController,
                  ),
                ),
              ),
              AppSpacing.medium(context),
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
                  AppSpacing.small(context),
                  Expanded(
                    child: PrimaryButton(
                      text: "Save",
                      onPressed: submitForm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
