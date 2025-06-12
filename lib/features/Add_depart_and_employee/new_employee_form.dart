import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hr_management/config/App_margin.dart';
import 'package:hr_management/core/widgets/Company_logo_picker.dart';
import 'package:hr_management/core/widgets/custom_dropdown.dart';
import 'package:hr_management/core/widgets/Leave_Container.dart';
import 'package:hr_management/core/widgets/primary_button.dart';
import 'package:hr_management/features/Add_depart_and_employee/constants/employee_constants.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/department_type_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/fetch_employee_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/job_type_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/new_employee_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/controller/position_controller.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/department_type_model.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/job_type_model.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/new_employee_model.dart';
import 'package:hr_management/features/Add_depart_and_employee/models/position_model.dart';
import 'package:hr_management/features/Add_depart_and_employee/utils/validation_utils.dart';
import 'package:hr_management/features/Add_depart_and_employee/widgets/form_section.dart';
import 'package:hr_management/features/Add_depart_and_employee/widgets/required_text_field.dart';
import 'package:hr_management/features/Add_depart_and_employee/widgets/required_dropdown.dart';
import 'package:hr_management/features/Company_details/Widgets/custom_text_field.dart';
import 'package:hr_management/features/Company_details/Widgets/upload_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/custom_toast.dart';

class NewEmployeeForm extends StatefulWidget {
  final String? empId;
  const NewEmployeeForm({super.key, this.empId});

  @override
  State<NewEmployeeForm> createState() => _NewEmployeeFormState();
}

class _NewEmployeeFormState extends State<NewEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController employeeCodeController;
  late final TextEditingController startDateController;

  final RxString selectedGender = ''.obs;
  final RxString selectedUserRole = ''.obs;
  final RxBool isFormModified = false.obs;
  final RxBool showRequired = false.obs;
  final RxBool isLoading = true.obs;

  File? panImage;
  File? profileImage;
  String? profileImageUrl;
  String? panImageUrl;

  // Initial values for form modification tracking
  String? initialName, initialPhone, initialEmail, initialEmployeeCode;
  String? initialStartDate, initialGender, initialUserRole;
  String? initialDepartmentId, initialJobTypeId, initialPositionId;
  String? initialProfileImageUrl, initialPanImageUrl;

  // Controllers
  late final JobTypeController jobTypeController;
  late final PositionController positionController;
  late final FetchEmployeeController fetchController;
  late final DepartmentTypeController departmentController;
  late final NewEmployeeController employeeController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeForm();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    employeeCodeController = TextEditingController();
    startDateController = TextEditingController();

    jobTypeController = Get.put(JobTypeController());
    positionController = Get.put(PositionController());
    fetchController = Get.put(FetchEmployeeController());
    departmentController = Get.put(DepartmentTypeController());
    employeeController = Get.put(NewEmployeeController());
  }

  Future<void> _initializeForm() async {
    try {
      departmentController.fetchDepartments();
      if (widget.empId != null) {
        await _loadExistingEmployee();
      } else {
        isFormModified.value = true;
        _addFormListeners();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadExistingEmployee() async {
    try {
      await fetchController.fetchEmployeeById(widget.empId!);
      final data = fetchController.fetchEmployee.value;
      if (data != null) {
        setState(() {
          profileImageUrl = data.profileUrl;
          panImageUrl = data.panUrl;
        });
        _populateFormData(data);
      }
    } catch (e) {
      CustomToast.showMessage(
        context: context,
        title: 'Error',
        message: 'Failed to load employee data',
        isError: true,
      );
    }
  }

  void _populateFormData(dynamic data) {
    nameController.text = data.name ?? '';
    phoneController.text = data.phone ?? '';
    emailController.text = data.email ?? '';
    employeeCodeController.text = data.employeeCode ?? '';
    startDateController.text = data.doj ?? '';
    selectedGender.value = data.gender ?? '';
    selectedUserRole.value = EmployeeConstants.roleMap.entries
        .firstWhere((e) => e.value == data.userRoleId, orElse: () => const MapEntry('', ''))
        .key;
    _storeInitialValues(data);
    _setInitialSelections(data);
    _addFormListeners();
  }

  void _setInitialSelections(dynamic data) {
    departmentController.selectedDepartment.value = departmentController.departmentList
        .firstWhereOrNull((dept) => dept.id == data.departmentId);
    jobTypeController.selectedJobType.value = jobTypeController.jobTypes
        .firstWhereOrNull((type) => type.id == data.empType);
    positionController.selectedPosition.value = positionController.positions
        .firstWhereOrNull((pos) => pos.id == data.positionId);
  }

  void _storeInitialValues(dynamic data) {
    initialName = data.name ?? '';
    initialPhone = data.phone ?? '';
    initialEmail = data.email ?? '';
    initialEmployeeCode = data.employeeCode ?? '';
    initialStartDate = data.doj ?? '';
    initialGender = data.gender ?? '';
    initialUserRole = EmployeeConstants.roleMap.entries
        .firstWhere((e) => e.value == data.userRoleId, orElse: () => const MapEntry('', ''))
        .key;
    initialDepartmentId = data.departmentId;
    initialJobTypeId = data.empType;
    initialPositionId = data.positionId;
    initialProfileImageUrl = data.profileUrl;
    initialPanImageUrl = data.panUrl;
  }

  void _addFormListeners() {
    nameController.addListener(_checkFormModification);
    phoneController.addListener(_checkFormModification);
    emailController.addListener(_checkFormModification);
    employeeCodeController.addListener(_checkFormModification);
    startDateController.addListener(_checkFormModification);
    selectedGender.listen((_) => _checkFormModification());
    selectedUserRole.listen((_) => _checkFormModification());
    departmentController.selectedDepartment.listen((_) => _checkFormModification());
    jobTypeController.selectedJobType.listen((_) => _checkFormModification());
    positionController.selectedPosition.listen((_) => _checkFormModification());
  }

  void _checkFormModification() {
    if (widget.empId == null) {
      isFormModified.value = true;
      return;
    }

    isFormModified.value = 
        nameController.text != (initialName ?? '') ||
        phoneController.text != (initialPhone ?? '') ||
        emailController.text != (initialEmail ?? '') ||
        employeeCodeController.text != (initialEmployeeCode ?? '') ||
        startDateController.text != (initialStartDate ?? '') ||
        selectedGender.value != (initialGender ?? '') ||
        selectedUserRole.value != (initialUserRole ?? '') ||
        departmentController.selectedDepartment.value?.id != initialDepartmentId ||
        jobTypeController.selectedJobType.value?.id != initialJobTypeId ||
        positionController.selectedPosition.value?.id != initialPositionId ||
        profileImage != null ||
        panImage != null;
  }

  Future<void> _submitForm() async {
    showRequired.value = true;
    
    // Check if any required field is empty
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        employeeCodeController.text.isEmpty ||
        startDateController.text.isEmpty ||
        selectedGender.value.isEmpty ||
        selectedUserRole.value.isEmpty ||
        departmentController.selectedDepartment.value == null ||
        jobTypeController.selectedJobType.value == null ||
        positionController.selectedPosition.value == null) {
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: "Please fill all required fields",
        isError: true,
      );
      return;
    }

    // Validate form fields
    if (!_validateForm()) {
      return;
    }

    final selectedRoleId = EmployeeConstants.roleMap[selectedUserRole.value];
    if (selectedRoleId == null) {
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: EmployeeConstants.invalidRole,
        isError: true,
      );
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final newEmployee = NewEmployeeModel(
        empName: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        empTypeId: jobTypeController.selectedJobType.value!.id,
        departmentId: departmentController.selectedDepartment.value!.id,
        gender: selectedGender.value,
        UserRoleId: selectedRoleId,
        positionId: positionController.selectedPosition.value!.id,
        EmployeeCode: employeeCodeController.text,
        date: startDateController.text,
      );

      if (widget.empId != null) {
        await employeeController.updateCurrentEmployee(widget.empId!, newEmployee);
        Get.back(); // Close loading dialog
        departmentController.fetchDepartments();
        employeeController.fetchEmployee('');
        Get.back(); // Return to previous screen
      } else {
        await employeeController.submitNewEmployee(newEmployee);
        Get.back(); // Close loading dialog
        departmentController.fetchDepartments();
        employeeController.fetchEmployee('');
        Get.back(); // Return to previous screen
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    }
  }

  bool _validateForm() {
    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text)) {
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: "Please enter a valid email address",
        isError: true,
      );
      return false;
    }

    // Validate phone number
    if (phoneController.text.length != 10) {
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: "Phone number must be 10 digits",
        isError: true,
      );
      return false;
    }

    // Validate start date
    if (startDateController.text.isEmpty) {
      CustomToast.showMessage(
        context: context,
        title: "Error",
        message: "Please select a joining date",
        isError: true,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    employeeCodeController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        FormSection(
          title: '',
          child: CompanyLogoPicker(
            title: EmployeeConstants.employeeProfileTitle,
            initialImage: profileImage?.path ?? profileImageUrl,
            onImageSelected: (File? file) {
              setState(() {
                profileImage = file;
                if (file != null) {
                  profileImageUrl = null;
                }
              });
              _checkFormModification();
            },
          ),
        ),
        FormSection(
          title: EmployeeConstants.fullNameTitle,
          child: Obx(() => RequiredTextField(
            hint: EmployeeConstants.employeeNameHint,
            controller: nameController,
            validator: ValidationUtils.validateName,
            showRequired: showRequired.value,
            fieldName: "employee name",
          )),
        ),
        FormSection(
          title: EmployeeConstants.positionTitle,
          child: Obx(() => RequiredDropdown<Position>(
            value: positionController.selectedPosition.value,
            items: positionController.positions,
            onChanged: (val) {
              positionController.selectPosition(val);
              _checkFormModification();
            },
            hint: EmployeeConstants.selectPositionHint,
            itemBuilder: (position) => Text(position.position),
            showRequired: showRequired.value,
            fieldName: "position",
          )),
        ),
        FormSection(
          title: EmployeeConstants.employmentTypeTitle,
          child: Obx(() => RequiredDropdown<JobType>(
            value: jobTypeController.selectedJobType.value,
            items: jobTypeController.jobTypes,
            onChanged: (val) {
              jobTypeController.selectJobType(val);
              _checkFormModification();
            },
            hint: EmployeeConstants.selectJobTypeHint,
            itemBuilder: (jobType) => Text(jobType.type),
            showRequired: showRequired.value,
            fieldName: "employment type",
          )),
        ),
        FormSection(
          title: EmployeeConstants.userRoleTitle,
          child: Obx(() => RequiredDropdown<String>(
            value: selectedUserRole.value.isEmpty ? null : selectedUserRole.value,
            items: EmployeeConstants.roleMap.keys.toList(),
            onChanged: (val) {
              selectedUserRole.value = val ?? '';
              _checkFormModification();
            },
            hint: EmployeeConstants.selectRoleHint,
            itemBuilder: (role) => Text(role),
            showRequired: showRequired.value,
            fieldName: "user role",
          )),
        ),
        FormSection(
          title: EmployeeConstants.employeeCodeTitle,
          child: Obx(() => RequiredTextField(
            hint: EmployeeConstants.employeeCodeHint,
            controller: employeeCodeController,
            showRequired: showRequired.value,
            fieldName: "employee code",
          )),
        ),
        FormSection(
          title: EmployeeConstants.departmentTitle,
          child: Obx(() {
            if (departmentController.isLoading.value) {
              return const CircularProgressIndicator();
            }
            return RequiredDropdown<DepartmentModel>(
              value: departmentController.selectedDepartment.value,
              items: departmentController.departmentList,
              onChanged: (val) {
                departmentController.selectDepartment(val);
                _checkFormModification();
              },
              hint: EmployeeConstants.selectDepartmentHint,
              itemBuilder: (dept) => Text(dept.department),
              showRequired: showRequired.value,
              fieldName: "department",
            );
          }),
        ),
        FormSection(
          title: EmployeeConstants.genderTitle,
          child: Obx(() => RequiredDropdown<String>(
            value: selectedGender.value.isEmpty ? null : selectedGender.value,
            items: EmployeeConstants.genderOptions,
            onChanged: (val) {
              selectedGender.value = val!;
              _checkFormModification();
            },
            hint: "Select Gender",
            itemBuilder: (gender) => Text(gender),
            showRequired: showRequired.value,
            fieldName: "gender",
          )),
        ),
        FormSection(
          title: EmployeeConstants.phoneNumberTitle,
          child: Obx(() => RequiredTextField(
            hint: EmployeeConstants.phoneHint,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: ValidationUtils.validatePhone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            showRequired: showRequired.value,
            fieldName: "phone number",
          )),
        ),
        FormSection(
          title: EmployeeConstants.emailTitle,
          child: Obx(() => RequiredTextField(
            hint: EmployeeConstants.emailHint,
            controller: emailController,
            validator: ValidationUtils.validateEmail,
            showRequired: showRequired.value,
            fieldName: "email",
          )),
        ),
        FormSection(
          title: EmployeeConstants.panCardTitle,
          child: UploadCard(
            title: EmployeeConstants.panCardTitle,
            onImageSelected: (file) {
              setState(() {
                panImage = file;
                if (file != null) {
                  panImageUrl = null;
                }
              });
              _checkFormModification();
            },
            initialImage: panImage?.path ?? panImageUrl ?? '',
          ),
        ),
        FormSection(
          title: EmployeeConstants.joiningDateTitle,
          child: Obx(() => RequiredTextField(
            hint: EmployeeConstants.joiningDateHint,
            controller: startDateController,
            validator: ValidationUtils.validateStartDate,
            showRequired: showRequired.value,
            fieldName: "joining date",
          )),
        ),
      ],
    );
  }

  Widget _buildButtonRow() {
    if (widget.empId != null) {
      return Obx(() {
        if (!isFormModified.value) {
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
        }
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
                onPressed: _submitForm,
              ),
            ),
          ],
        );
      });
    }
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
            text: "Save",
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.empId != null ? "Edit Employee Details" : "Add New Employee",
        leading: const BackButton(),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return AppMargin(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildFormFields(),
                  AppSpacing.small(context),
                  _buildButtonRow(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
