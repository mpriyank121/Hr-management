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
import 'controller/fetch_employee_controller.dart';
import 'controller/position_controller.dart';
import 'controller/new_employee_controller.dart';
import 'models/department_type_model.dart';
import 'models/new_employee_model.dart';
import 'models/position_model.dart';
import 'package:intl/intl.dart';

class NewEmployeeForm extends StatefulWidget {
  final String? empId;

  const NewEmployeeForm({super.key, this.empId});

  @override
  State<NewEmployeeForm> createState() => _NewEmployeeFormState();
}


class _NewEmployeeFormState extends State<NewEmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final employeeCodeController = TextEditingController();
  final startDateController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedUserRole = ''.obs;
  File? panImage;
  File? profileImage;

  final JobTypeController jobTypeController = Get.put(JobTypeController());
  final PositionController positionController = Get.put(PositionController());
  final FetchEmployeeController fetchController = Get.put(FetchEmployeeController());
  final DepartmentTypeController departmentController = Get.put(
    DepartmentTypeController(),
  );
  final NewEmployeeController employeeController = Get.put(
    NewEmployeeController(),
  );

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    employeeCodeController.dispose();
    startDateController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    fetchController.fetchEmployeeById('442');
    if (widget.empId != null) {
      fetchController.fetchEmployeeById(widget.empId!).then((_) {
        final data = fetchController.fetchEmployee.value;
        // ✅ Debug print the fetched employee data
        debugPrint('Fetched Employee Data: ${data.toString()}');
        if (data != null) {
          nameController.text = data.name ?? '';
          phoneController.text = data.phone ?? '';
          emailController.text = data.email ?? '';
          employeeCodeController.text = data.employeeCode ?? '';
          startDateController.text = data.doj ?? '';
          selectedGender.value = data.gender ?? '';
          selectedUserRole.value =
              roleMap.entries.firstWhere((e) => e.value == data.userRoleId,
                  orElse: () => const MapEntry('', '')).key;

          // Set dropdown values
          departmentController.selectedDepartment.value =
              departmentController.departmentList.firstWhereOrNull(
                    (dept) => dept.id == data.departmentId,
              );

          jobTypeController.selectedJobType.value =
              jobTypeController.jobTypes.firstWhereOrNull(
                    (type) => type.id == data.empType,
              );

          positionController.selectedPosition.value =
              positionController.positions.firstWhereOrNull(
                    (pos) => pos.id == data.positionId,
              );
        }
      });
    }
  }

  void submitForm() {
    if (!_formKey.currentState!.validate() ||
        selectedUserRole.value.isEmpty ||
        selectedGender.value.isEmpty ||
        departmentController.selectedDepartment.value == null ||
        jobTypeController.selectedJobType.value == null ||
        positionController.selectedPosition.value == null) {
      Get.snackbar("Error", "Please fill all required fields.");
      return;
    }
    final selectedRoleId = roleMap[selectedUserRole.value];
    if (selectedRoleId == null) {
      Get.snackbar("Error", "Invalid role selected.");
      return;
    }
    final newEmployee = NewEmployeeModel(
      empName: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      departmentId: departmentController.selectedDepartment.value!.id,
      gender: selectedGender.value,
      UserRoleId: selectedRoleId,
      positionId: positionController.selectedPosition.value!.id,
      EmployeeCode: employeeCodeController.text,
      empTypeId: jobTypeController.selectedJobType.value!.id,
      panFilePath: panImage?.path,
      date: startDateController.text,
      profilePath: profileImage?.path,
    );

    employeeController.submitNewEmployee(newEmployee);
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  final Map<String, String> roleMap = {"Admin": "1", "Employee": "2"};



  @override
  Widget build(BuildContext context) {
    // This will give "1" or "2"

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.empId != null ? "Edit Employee Details" : "Add New Employee",
        leading: const BackButton(),
      ),

      body: AppMargin(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  onPressed: pickProfileImage,
                  child: const Text("Upload Profile Picture"),
                ),
                AppSpacing.small(context),

                const SectionTitle(title: "Full Name"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Employee Name",
                  controller: nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Name is required" : null,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Position"),
                AppSpacing.small(context),
                Obx(() {
                  return LeaveContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<Position>(
                      value: positionController.selectedPosition.value,
                      hint: const Text('Select Position'),
                      isExpanded: true,
                      items: positionController.positions.map((position) {
                        return DropdownMenuItem<Position>(
                          value: position,
                          child: Text(position.position),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          positionController.selectPosition(val),
                      validator: (value) =>
                          value == null ? 'Position is required' : null,
                    ),
                  );
                }),

                AppSpacing.small(context),
                const SectionTitle(title: "Employment Type"),
                Obx(() {
                  return LeaveContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<JobType>(
                      value: jobTypeController.selectedJobType.value,
                      hint: const Text('Select Job Type'),
                      isExpanded: true,
                      items: jobTypeController.jobTypes.map((jobType) {
                        return DropdownMenuItem<JobType>(
                          value: jobType,
                          child: Text(jobType.type),
                        );
                      }).toList(),
                      onChanged: (val) => jobTypeController.selectJobType(val),
                      validator: (value) =>
                          value == null ? 'Job type is required' : null,
                    ),
                  );
                }),

                AppSpacing.small(context),
                const SectionTitle(title: "User Role"),
                LeaveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: selectedUserRole.value.isEmpty
                          ? null
                          : selectedUserRole.value,
                      hint: const Text("Select Role"),
                      isExpanded: true,
                      items: roleMap.keys.map((roleName) {
                        return DropdownMenuItem<String>(
                          value: roleName,
                          child: Text(roleName),
                        );
                      }).toList(),
                      onChanged: (val) => selectedUserRole.value = val!,
                      validator: (val) => val == null || val.isEmpty
                          ? 'User Role is required'
                          : null,
                    ),
                  ),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Employee Code"),
                CustomTextField(
                  hint: "Employee Code",
                  controller: employeeCodeController,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Department"),
                Obx(() {
                  if (departmentController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return LeaveContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<DepartmentModel>(
                        value: departmentController.selectedDepartment.value,
                        hint: const Text('Select Department'),
                        isExpanded: true,
                        items: departmentController.departmentList.map((dept) {
                          return DropdownMenuItem<DepartmentModel>(
                            value: dept,
                            child: Text(dept.department),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            departmentController.selectDepartment(val),
                        validator: (value) =>
                            value == null ? 'Department is required' : null,
                      ),
                    );
                  }
                }),

                AppSpacing.small(context),
                const SectionTitle(title: "Gender"),
                AppSpacing.small(context),
                LeaveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: selectedGender.value.isEmpty
                          ? null
                          : selectedGender.value,
                      hint: const Text("Select Gender"),
                      isExpanded: true,
                      items: ["Male", "Female", "Other"].map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (val) => selectedGender.value = val!,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Gender is required'
                          : null,
                    ),
                  ),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Phone Number"),
                CustomTextField(
                  hint: "Enter Number",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty ? "Phone is required" : null,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Email"),
                CustomTextField(
                  hint: "example@gmail.com",
                  controller: emailController,
                  validator: (val) => val!.isEmpty ? "Email is required" : null,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Employee Identification Document"),
                UploadCard(
                  title: "Upload your PAN card",
                  onImageSelected: (file) => panImage = file,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Start Date of Employment"),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      startDateController.text = DateFormat(
                        'yyyy/MM/dd',
                      ).format(picked);
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hint: "Start Date",
                      controller: startDateController,
                      validator: (val) =>
                          val!.isEmpty ? "Start date required" : null,
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
                      child: PrimaryButton(text: "Save", onPressed: submitForm),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
