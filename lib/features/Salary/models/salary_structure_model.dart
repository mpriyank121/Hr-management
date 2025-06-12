class SalaryStructureModel {
  final String employeeCode;
  final String employeeName;
  final String departmentId;
  final String salaryType; // "CTC" or "Take Home"
  final double basicSalary;
  final double hra;
  final double pf;
  final double esi;
  final double professionalTax;
  final double totalDeductions;
  final double netSalary;
  final double ctc;

  SalaryStructureModel({
    required this.employeeCode,
    required this.employeeName,
    required this.departmentId,
    required this.salaryType,
    required this.basicSalary,
    required this.hra,
    required this.pf,
    required this.esi,
    required this.professionalTax,
    required this.totalDeductions,
    required this.netSalary,
    required this.ctc,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'department_id': departmentId,
      'salary_type': salaryType,
      'basic_salary': basicSalary,
      'hra': hra,
      'pf': pf,
      'esi': esi,
      'professional_tax': professionalTax,
      'total_deductions': totalDeductions,
      'net_salary': netSalary,
      'ctc': ctc,
    };
  }
} 