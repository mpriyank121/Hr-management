import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/core/widgets/Company_logo_picker.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
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
import 'package:flutter/services.dart';

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
  String? profileImageUrl;
  String? panImageUrl;

  // Variables to track initial values for comparison
  String? initialName;
  String? initialPhone;
  String? initialEmail;
  String? initialEmployeeCode;
  String? initialStartDate;
  String? initialGender;
  String? initialUserRole;
  String? initialDepartmentId;
  String? initialJobTypeId;
  String? initialPositionId;
  String? initialProfileImageUrl;
  String? initialPanImageUrl;

  // Observable to track if form has been modified
  final RxBool isFormModified = false.obs;

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

    if (widget.empId != null) {
      // Editing existing employee
      fetchController.fetchEmployeeById(widget.empId!).then((_) {
        final data = fetchController.fetchEmployee.value;

        debugPrint('Fetched Employee Data: ${data.toString()}');
        if (data != null) {
          profileImageUrl = data.profileUrl;
          panImageUrl = data.panUrl;

          nameController.text = data.name ?? '';
          phoneController.text = data.phone ?? '';
          emailController.text = data.email ?? '';
          employeeCodeController.text = data.employeeCode ?? '';
          startDateController.text = data.doj ?? '';
          selectedGender.value = data.gender ?? '';
          selectedUserRole.value =
              roleMap.entries.firstWhere((e) => e.value == data.userRoleId,
                  orElse: () => const MapEntry('', '')).key;

          // Store initial values for change tracking
          _storeInitialValues(data);

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

          // Add listeners after setting initial values
          _addFormListeners();
        }
      });
    } else {
      // Creating new employee - always show Save button
      isFormModified.value = true;
      _addFormListeners();
    }
  }

  void _storeInitialValues(dynamic data) {
    initialName = data.name ?? '';
    initialPhone = data.phone ?? '';
    initialEmail = data.email ?? '';
    initialEmployeeCode = data.employeeCode ?? '';
    initialStartDate = data.doj ?? '';
    initialGender = data.gender ?? '';
    initialUserRole = roleMap.entries.firstWhere((e) => e.value == data.userRoleId,
        orElse: () => const MapEntry('', '')).key;
    initialDepartmentId = data.departmentId;
    initialJobTypeId = data.empType;
    initialPositionId = data.positionId;
    initialProfileImageUrl = data.profileUrl;
    initialPanImageUrl = data.panUrl;
  }

  void _addFormListeners() {
    // Add listeners to text controllers
    nameController.addListener(_checkFormModification);
    phoneController.addListener(_checkFormModification);
    emailController.addListener(_checkFormModification);
    employeeCodeController.addListener(_checkFormModification);
    startDateController.addListener(_checkFormModification);

    // Add listeners to observables
    selectedGender.listen((_) => _checkFormModification());
    selectedUserRole.listen((_) => _checkFormModification());
    departmentController.selectedDepartment.listen((_) => _checkFormModification());
    jobTypeController.selectedJobType.listen((_) => _checkFormModification());
    positionController.selectedPosition.listen((_) => _checkFormModification());
  }

  void _checkFormModification() {
    if (widget.empId == null) {
      // For new employee, always show Save button
      isFormModified.value = true;
      return;
    }

    // Check if any field has been modified
    bool hasChanges = false;

    if (nameController.text != (initialName ?? '')) hasChanges = true;
    if (phoneController.text != (initialPhone ?? '')) hasChanges = true;
    if (emailController.text != (initialEmail ?? '')) hasChanges = true;
    if (employeeCodeController.text != (initialEmployeeCode ?? '')) hasChanges = true;
    if (startDateController.text != (initialStartDate ?? '')) hasChanges = true;
    if (selectedGender.value != (initialGender ?? '')) hasChanges = true;
    if (selectedUserRole.value != (initialUserRole ?? '')) hasChanges = true;

    // Check dropdown selections
    if (departmentController.selectedDepartment.value?.id != initialDepartmentId) hasChanges = true;
    if (jobTypeController.selectedJobType.value?.id != initialJobTypeId) hasChanges = true;
    if (positionController.selectedPosition.value?.id != initialPositionId) hasChanges = true;

    // Check images
    if (profileImage != null) hasChanges = true;
    if (panImage != null) hasChanges = true;

    isFormModified.value = hasChanges;
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

    if (widget.empId != null) {
      // Update existing employee
      employeeController.updateCurrentEmployee(widget.empId!, newEmployee);
    } else {
      // Create new employee
      employeeController.submitNewEmployee(newEmployee);
    }
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
      _checkFormModification();
    }
  }

  final Map<String, String> roleMap = {"Admin": "1", "Employee": "2"};

  @override
  Widget build(BuildContext context) {
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
                CompanyLogoPicker(
                  title: "Employee Profile",
                  initialImage: profileImage != null
                      ? profileImage!.path
                      : profileImageUrl,
                  onImageSelected: (File? file) {
                    setState(() {
                      profileImage = file;
                    });
                    _checkFormModification();
                  },
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
                    child: CustomDropdown<Position>(
                      value: positionController.selectedPosition.value,
                      items: positionController.positions.map((position) {
                        return DropdownMenuItem<Position>(
                          value: position,
                          child: Text(position.position),
                        );
                      }).toList(),
                      onChanged: (val) {
                        positionController.selectPosition(val);
                        _checkFormModification();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Select Position',
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
                AppSpacing.small(context),
                const SectionTitle(title: "Employment Type"),
                AppSpacing.small(context),
              Obx(() {
                return LeaveContainer(
                  child: CustomDropdown<JobType>(
                    value: jobTypeController.selectedJobType.value,
                    items: jobTypeController.jobTypes.map((jobType) {
                      return DropdownMenuItem<JobType>(
                        value: jobType,
                        child: Text(jobType.type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      jobTypeController.selectJobType(val);
                      _checkFormModification();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select Job Type',
                      border: InputBorder.none,
                    ),
                  ),
                );
              }),

                AppSpacing.small(context),
                const SectionTitle(title: "User Role"),
                AppSpacing.small(context),
                LeaveContainer(
                  child: Obx(() => CustomDropdown<String>(
                    value: selectedUserRole.value.isEmpty ? null : selectedUserRole.value,
                    items: roleMap.keys.map((roleName) {
                      return DropdownMenuItem<String>(
                        value: roleName,
                        child: Text(roleName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      selectedUserRole.value = val ?? '';
                      _checkFormModification();
                    },
                    decoration: const InputDecoration(
                      hintText: "Select Role",
                      border: InputBorder.none,
                    ),
                  )),
                ),
                AppSpacing.small(context),
                const SectionTitle(title: "Employee Code"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Employee Code",
                  controller: employeeCodeController,
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Department"),
                AppSpacing.small(context),
                Obx(() {
                  if (departmentController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return LeaveContainer(
                      child: CustomDropdown<DepartmentModel>(
                        value: departmentController.selectedDepartment.value,
                        items: departmentController.departmentList.map((dept) {
                          return DropdownMenuItem<DepartmentModel>(
                            value: dept,
                            child: Text(dept.department),
                          );
                        }).toList(),
                        onChanged: (val) {
                          departmentController.selectDepartment(val);
                          _checkFormModification();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Select Department',
                          border: InputBorder.none,
                        ),
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
                        () => CustomDropdown<String>(
                      value: selectedGender.value.isEmpty
                          ? null
                          : selectedGender.value,
                      items: ["Male", "Female", "Other"].map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (val) {
                        selectedGender.value = val!;
                        _checkFormModification();
                      },
                      // validator: (val) => val == null || val.isEmpty
                      //     ? 'Gender is required'
                      //     : null,
                    ),
                  ),
                ),
                AppSpacing.small(context),
                const SectionTitle(title: "Phone Number"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "Enter Number",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                  val == null || val.isEmpty ? "Phone is required" : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,          // Allow only digits
                    LengthLimitingTextInputFormatter(10),            // Limit to 10 characters max
                  ],
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Email"),
                AppSpacing.small(context),
                CustomTextField(
                  hint: "example@gmail.com",
                  controller: emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Email is required";
                    }
                    // Simple email regex check
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(val)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Employee Identification Document"),
                AppSpacing.small(context),
                UploadCard(
                  title: "Upload your PAN card",
                  onImageSelected: (file) {
                    panImage = file;
                    _checkFormModification();
                  },
                  initialImage: panImage != null
                      ? panImage!.path
                      : (panImageUrl ?? ''),
                ),

                AppSpacing.small(context),
                const SectionTitle(title: "Start Date of Employment"),
                AppSpacing.small(context),
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
                      _checkFormModification();
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

                AppSpacing.small(context),
                // Dynamic Button Row based on form state
                // Move the empId check outside Obx
                widget.empId != null
                    ? Obx(() {
                  if (!isFormModified.value) {
                    // Edit mode but no changes - show only Cancel
                    return Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            textColor: const Color(0xFFF25922),
                            buttonColor: const Color(0x19CD0909),
                            text: "Cancel",
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Edit mode with changes - show Cancel + Update
                    return Row(
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
                            text: "Update",
                            onPressed: submitForm,
                          ),
                        ),
                      ],
                    );
                  }
                })
                    : Row(
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
      ),
    );
  }
}