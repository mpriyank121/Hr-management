class SalaryStructureModel {
  final String employeeCode;
  final String employeeName;
  final String departmentId;
  final String salaryType; // "CTC" or "Take Home"
  final double basicSalary;
  final double pf;
  final double esi;
  final double hra;
  final double totalDeductions;
  final double netSalary;
  final double ctc;
  final double? otherAllowances;
  final int? deductionKey;
  final double? proffesionalTax;

  SalaryStructureModel({
    required this.employeeCode,
    required this.employeeName,
    required this.departmentId,
    required this.salaryType,
    required this.basicSalary,
    required this.pf,
    required this.esi,
    required this.hra,
    required this.totalDeductions,
    required this.netSalary,
    required this.ctc,
    this.deductionKey,
    this.otherAllowances,
    required this.proffesionalTax

  });

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'employee_name': employeeName,
      'department_id': departmentId,
      'hra': hra,
      'total_deductions': totalDeductions,
      'net_amount': netSalary,
      "basic_pay" : basicSalary,
      "pf_employee" : pf,
      "other_pay" : otherAllowances,
      "esic_employee" : esi,
      "ctc" : ctc,
      "salary_type" : salaryType,
      "tax" : proffesionalTax
    };
  }
}