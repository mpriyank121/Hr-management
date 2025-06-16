import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/App_margin.dart';
import '../../config/app_colors.dart';
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

  final List<String> selectedDeductions = [];

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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              hint: "Enter Amount",
                              controller: basicSalaryController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow decimals
                              ],
                            ),
                          ),
                          const SizedBox(width: 8), // Add spacing between TextField and Button
                          Expanded(
                            flex: 1,
                            child: PrimaryButton(
                              heightFactor: 0.05,
                              text: "Calculate",
                              onPressed: () {
                                if (basicSalaryController.text.isNotEmpty) {
                                  try {
                                    final amount = double.parse(basicSalaryController.text);
                                    final deductionKey = _getDeductionKey();
                                    _salaryController.updateDeductionKey(deductionKey);
                                    _salaryController.updateDeductions(selectedDeductions);
                                    _salaryController.fetchDeductionsFromAPI(amount);
                                  } catch (e) {
                                    CustomToast.showMessage(
                                      context: context,
                                      title: "Error",
                                      message: "Please enter a valid amount",
                                      isError: true,
                                    );
                                  }
                                } else {
                                  CustomToast.showMessage(
                                    context: context,
                                    title: "Error",
                                    message: "Please enter amount",
                                    isError: true,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.small(context),
                      // Show ESI/PF selector only for CTC
                      FormSection(
                        title: "Select Deduction",
                        child: Obx(() {
                          if (_salaryController.salaryType.value == "CTC") {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      // Deduction chips section
                                      Expanded(
                                        flex: 2,
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _buildDeductionChip('PF'),
                                            _buildDeductionChip('ESI'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Calculate button section

                                    ],
                                  ),
                                ),

                                AppSpacing.medium(context),

                                // Salary details with consistent spacing
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildSalaryRow("CTC(Cost To Company)", _salaryController.ctc.value),
                                      const SizedBox(height: 12),
                                      _buildSalaryRow("Base Salary", _salaryController.basicSalary.value),
                                      const SizedBox(height: 12),
                                      _buildSalaryRow("HRA", _salaryController.hra.value),
                                      const SizedBox(height: 12),
                                      _buildSalaryRow("Other Allowances", _salaryController.otherallowance.value),

                                      if (selectedDeductions.contains('PF')) ...[
                                        const SizedBox(height: 12),
                                        _buildSalaryRow("PF", _salaryController.pf.value),
                                      ],
                                      if (selectedDeductions.contains('ESI')) ...[
                                        const SizedBox(height: 12),
                                        _buildSalaryRow("ESI", _salaryController.esi.value),
                                      ],

                                      if (selectedDeductions.isNotEmpty) ...[
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          child: Divider(height: 1, color: Colors.grey),
                                        ),
                                        _buildSalaryRow("Total Deductions", _salaryController.totalDeductions.value),
                                        const SizedBox(height: 12),
                                      ],
                                      _buildSalaryRow("Net Salary", _salaryController.netSalary.value),

                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                             child :Column(children: [
                               _buildSalaryRow("CTC(Cost To Company)", _salaryController.ctc.value),
                               const SizedBox(height: 12),
                               _buildSalaryRow("Base Salary", _salaryController.basicSalary.value),
                               const SizedBox(height: 12),
                               _buildSalaryRow("HRA", _salaryController.hra.value),
                               const SizedBox(height: 12),
                               _buildSalaryRow("Other Allowances", _salaryController.otherallowance.value),
                               const SizedBox(height: 12),
                               _buildSalaryRow("Net Salary", _salaryController.netSalary.value),],)
                            );

                          }
                        }),
                      ),
                    ],
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
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final model = SalaryStructureModel(
                            employeeCode: employeeCodeController.text,
                            employeeName: employeeNameController.text,
                            departmentId: _departmentController.selectedDepartment.value!.id,
                            salaryType: _salaryController.getSalaryTypeCode().toString(),
                            basicSalary: _salaryController.basicSalary.value,
                            pf: selectedDeductions.contains('PF') ? _salaryController.pf.value : 0,
                            esi: selectedDeductions.contains('ESI') ? _salaryController.esi.value : 0,
                            otherAllowances: _salaryController.otherallowance.value,
                            hra: _salaryController.hra.value,
                            totalDeductions: _salaryController.totalDeductions.value,
                            netSalary: _salaryController.netSalary.value,
                            ctc: _salaryController.ctc.value,
                          );

                          await _salaryController.submitSalaryStructure(model);
                        },
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

// Add this method to get the deduction key
int _getDeductionKey() {
  final hasPF = selectedDeductions.contains('PF');
  final hasESI = selectedDeductions.contains('ESI');

  if (hasPF && hasESI) {
    return 3; // Both PF and ESI selected
  } else if (hasESI) {
    return 2; // Only ESI selected
  } else if (hasPF) {
    return 1; // Only PF selected
  } else {
    return 0; // None selected
  }
}

// Updated _buildDeductionChip method
Widget _buildDeductionChip(String label) {
  final isSelected = selectedDeductions.contains(label);
  return FilterChip(
    label: Text(label),
    selected: isSelected,
    onSelected: (selected) {
      setState(() {
        if (selected) {
          selectedDeductions.add(label);
        } else {
          selectedDeductions.remove(label);
        }
      });
      // Automatically call API when selections change
      if (basicSalaryController.text.isNotEmpty) {
        try {
          final amount = double.parse(basicSalaryController.text);
          final deductionKey = _getDeductionKey();
          _salaryController.updateDeductionKey(deductionKey);
          _salaryController.updateDeductions(selectedDeductions);
          _salaryController.fetchDeductionsFromAPI(amount);
        } catch (e) {
          CustomToast.showMessage(
            context: context,
            title: "Error",
            message: "Please enter a valid amount",
            isError: true,
          );
        }
      }
    },
    selectedColor: AppColors.secondary,
    checkmarkColor: Colors.white,
    backgroundColor: Colors.grey[200],
    showCheckmark: true,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    labelStyle: TextStyle(
      color: isSelected ? Colors.white : Colors.black87,
      fontWeight: FontWeight.w500,
    ),
    avatar: Icon(
      Icons.check,
      size: 16,
      color: isSelected ? Colors.white : Colors.grey[600],
    ),
  );
}

}