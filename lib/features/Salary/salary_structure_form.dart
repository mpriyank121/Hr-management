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
  final String? employeeCode;
  final String? employeeName;
  final String? departmentId;
  final String? salary;

  const SalaryStructureForm({
    Key? key,
    this.employeeCode,
    this.employeeName,
    this.departmentId,
    this.salary,
  }) : super(key: key);

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
  late final TextEditingController salaryController;
  late final TextEditingController workingDaysController;
  late final TextEditingController ctcController;

  final List<String> selectedDeductions = [];
  String selectedMonth = "";
  final List<String> months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  bool deductFullPfFromEmployee = false;

  @override
  void initState() {
    super.initState();
    employeeCodeController = TextEditingController(text: widget.employeeCode ?? "");
    employeeNameController = TextEditingController(text: widget.employeeName ?? "");
    basicSalaryController = TextEditingController();
    salaryController = TextEditingController(text: widget.salary ?? "");
    workingDaysController = TextEditingController();
    ctcController = TextEditingController();
    _departmentController.fetchDepartments().then((_) {
      if (widget.departmentId != null) {
        final dept = _departmentController.departmentList.firstWhereOrNull((d) => d.id == widget.departmentId);
        if (dept != null) {
          _departmentController.selectDepartment(dept);
        }
      }
    });
    selectedMonth = months[DateTime.now().month - 1];
  }

  @override
  void dispose() {
    employeeCodeController.dispose();
    employeeNameController.dispose();
    basicSalaryController.dispose();
    salaryController.dispose();
    workingDaysController.dispose();
    ctcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ""
            "Add Employee Monthly Salary",
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
                              hint: "Salary",
                              controller: salaryController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: PrimaryButton(
                              heightFactor: 0.05,
                              text: "Calculate",
                              onPressed: () async {
                                if (salaryController.text.isNotEmpty) {
                                  try {
                                    final amount = double.parse(salaryController.text);
                                    final deductionKey = _getDeductionKey();
                                    _salaryController.updateDeductionKey(deductionKey);
                                    _salaryController.updateDeductions(selectedDeductions);
                                    await _salaryController.fetchDeductionsFromAPI(amount);
                                    // Recalculate net salary based on PF switch
                                    setState(() {});
                                  } catch (e) {
                                    CustomToast.showMessage(
                                      context: context,
                                      title: "Error",
                                      message: "Please enter a valid salary",
                                      isError: true,
                                    );
                                  }
                                } else {
                                  CustomToast.showMessage(
                                    context: context,
                                    title: "Error",
                                    message: "Salary is required",
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
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: [
                                            _buildDeductionChip('PF'),
                                            _buildDeductionChip('ESI'),
                                            _buildDeductionChip('PF from Employee',
                                              isFullPf: true,
                                              selected: deductFullPfFromEmployee,
                                              onSelected: (selected) {
                                                setState(() {
                                                  deductFullPfFromEmployee = selected;
                                                });
                                              },
                                            ),
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
                                      if (_salaryController.professionalTax != null && _salaryController.professionalTax.value > 0) ...[
                                        const SizedBox(height: 12),
                                        _buildSalaryRow("Professional Tax", _salaryController.professionalTax.value),
                                      ],
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
                                      const SizedBox(height: 12),
                                      _buildSalaryRow(
                                        deductFullPfFromEmployee ? "PF Deducted (Employee + Employer)" : "PF Deducted (Employee)",
                                        _salaryController.pf.value * (deductFullPfFromEmployee ? 2 : 1),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildSalaryRow(
                                        "Net Salary",
                                        (salaryController.text.isNotEmpty
                                          ? double.tryParse(salaryController.text) ?? 0
                                          : 0)
                                          - (_salaryController.pf.value * (deductFullPfFromEmployee ? 2 : 1))
                                          - _salaryController.esi.value
                                          - _salaryController.professionalTax.value
                                          - _salaryController.totalDeductions.value
                                          + _salaryController.pf.value // add back employee PF if totalDeductions already includes it
                                      ),
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
                            proffesionalTax: _salaryController.professionalTax.value
                          );
                          await _salaryController.submitSalaryStructure(model);
                        },
                      ),
                    ),
                  ],
                ),
                // Replace SwitchListTile with deduction chip for full PF

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

// Update _buildDeductionChip to support custom label and callback
Widget _buildDeductionChip(String label, {bool isFullPf = false, bool selected = false, ValueChanged<bool>? onSelected}) {
  if (isFullPf) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColors.secondary,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      showCheckmark: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      avatar: Icon(
        Icons.check,
        size: 16,
        color: selected ? Colors.white : Colors.grey[600],
      ),
    );
  }
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
      if (salaryController.text.isNotEmpty) {
        try {
          final amount = double.parse(salaryController.text);
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