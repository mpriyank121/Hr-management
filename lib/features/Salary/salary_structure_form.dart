import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/App_margin.dart';
import '../../config/app_spacing.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../Add_depart_and_employee/controller/department_type_controller.dart';
import '../Add_depart_and_employee/models/department_type_model.dart';
import '../Add_depart_and_employee/widgets/form_section.dart';
import '../Add_depart_and_employee/widgets/required_dropdown.dart';
import '../Add_depart_and_employee/widgets/required_text_field.dart';
import '../Company_details/Widgets/custom_text_field.dart';
import 'controllers/salary_structure_controller.dart';
import 'models/salary_structure_model.dart';
import '../../core/widgets/custom_toast.dart';

class SalaryStructureForm extends StatefulWidget {
  const SalaryStructureForm({super.key});

  @override
  State<SalaryStructureForm> createState() => _SalaryStructureFormState();
}

class _SalaryStructureFormState extends State<SalaryStructureForm> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = Get.put(SalaryStructureController());
  final _departmentController = Get.put(DepartmentTypeController());
  
  late final TextEditingController employeeCodeController;
  late final TextEditingController employeeNameController;
  late final TextEditingController basicSalaryController;
  late final TextEditingController ctcController;

  @override
  void initState() {
    super.initState();
    employeeCodeController = TextEditingController();
    employeeNameController = TextEditingController();
    basicSalaryController = TextEditingController();
    ctcController = TextEditingController();
    _departmentController.fetchDepartments();
  }

  @override
  void dispose() {
    employeeCodeController.dispose();
    employeeNameController.dispose();
    basicSalaryController.dispose();
    ctcController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final model = SalaryStructureModel(
      employeeCode: employeeCodeController.text,
      employeeName: employeeNameController.text,
      departmentId: _departmentController.selectedDepartment.value!.id,
      salaryType: _salaryController.salaryType.value,
      basicSalary: _salaryController.basicSalary.value,
      hra: _salaryController.hra.value,
      pf: _salaryController.pf.value,
      esi: _salaryController.esi.value,
      professionalTax: _salaryController.professionalTax.value,
      totalDeductions: _salaryController.totalDeductions.value,
      netSalary: _salaryController.netSalary.value,
      ctc: _salaryController.ctc.value,
    );

    _salaryController.submitSalaryStructure(model).then((success) {
      if (success) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Salary Structure",
        leading: const BackButton(),
      ),
      body: AppMargin(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormSection(
                  title: "Employee Details",
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RequiredTextField(
                              hint: "Employee Code",
                              controller: employeeCodeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Employee code is required";
                                }
                                return null;
                              },
                              fieldName: 'Employee Code',
                            ),
                          ),
                          AppSpacing.small(context),
                          PrimaryButton(
                            widthFactor: 0.3,
                            heightFactor: 0.05,
                            text: "Fetch",
                            onPressed: () async {
                              if (employeeCodeController.text.isNotEmpty) {
                                final success = await _salaryController.fetchEmployeeDetails(
                                  employeeCodeController.text,
                                );
                                if (success) {
                                  employeeNameController.text = _salaryController.employeeName.value;
                                  if (_salaryController.departmentName.value.isNotEmpty) {
                                    final dept = _departmentController.departmentList.firstWhere(
                                      (d) => d.department == _salaryController.departmentName.value,
                                      orElse: () => _departmentController.departmentList.first,
                                    );
                                    _departmentController.selectDepartment(dept);
                                  }
                                } else {
                                  employeeNameController.clear();
                                  CustomToast.showMessage(
                                    context: context,
                                    title: "Error",
                                    message: "Employee code not found",
                                    isError: true,
                                  );
                                }
                              } else {
                                CustomToast.showMessage(
                                  context: context,
                                  title: "Error",
                                  message: "Please enter employee code",
                                  isError: true,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      AppSpacing.small(context),
                      RequiredTextField(
                        hint: "Employee Name",
                        controller: employeeNameController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Employee name is required";
                          }
                          return null;
                        },
                        fieldName: 'Employee Name',
                      ),
                      AppSpacing.small(context),
                      Obx(() => RequiredDropdown<DepartmentModel>(
                        value: _departmentController.selectedDepartment.value,
                        items: _departmentController.departmentList,
                        onChanged: (val) {
                          _departmentController.selectDepartment(val);
                        },
                        hint: "Select Department",
                        itemBuilder: (dept) => Text(dept.department),
                        fieldName: "department",
                      )),
                    ],
                  ),
                ),
                FormSection(
                  title: "Salary Details",
                  child: Column(
                    children: [
                      Obx(() => RequiredDropdown<String>(
                        value: _salaryController.salaryType.value,
                        items: ["CTC", "Take Home"],
                        onChanged: (val) {
                          _salaryController.updateSalaryType(val!);
                        },
                        hint: "Select Salary Type",
                        itemBuilder: (type) => Text(type),
                        fieldName: "salary type",
                      )),
                      AppSpacing.small(context),
                      if (_salaryController.salaryType.value == "CTC")
                        CustomTextField(
                          hint: "Enter CTC",
                          controller: ctcController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _salaryController.updateCTC(double.parse(value));
                            }
                          },
                        )
                      else
                        CustomTextField(
                          hint: "Enter Basic Salary",
                          controller: basicSalaryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _salaryController.updateBasicSalary(double.parse(value));
                            }
                          },
                        ),
                    ],
                  ),
                ),
                FormSection(
                  title: "Salary Breakdown",
                  child: Obx(() => Column(
                    children: [
                      _buildSalaryRow("Basic Salary", _salaryController.basicSalary.value),
                      _buildSalaryRow("HRA", _salaryController.hra.value),
                      _buildSalaryRow("PF", _salaryController.pf.value),
                      _buildSalaryRow("ESI", _salaryController.esi.value),
                      _buildSalaryRow("Professional Tax", _salaryController.professionalTax.value),
                      const Divider(),
                      _buildSalaryRow("Total Deductions", _salaryController.totalDeductions.value),
                      _buildSalaryRow("Net Salary", _salaryController.netSalary.value),
                      if (_salaryController.salaryType.value == "Take Home")
                        _buildSalaryRow("CTC", _salaryController.ctc.value),
                    ],
                  )),
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
                        onPressed: _submitForm,
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

  Widget _buildSalaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
} 