import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/salary_structure_model.dart';

class SalaryStructureService {
  static Future<bool> submitSalaryStructure(SalaryStructureModel model) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();

      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
        body: {
          'type': EncryptionHelper.encryptString("addSalaryStructure"),
          'mob': EncryptionHelper.encryptString(storedPhone ?? ''),
          'employee_code': model.employeeCode,
          'employee_name': model.employeeName,
          'department_id': model.departmentId,
          'salary_type': model.salaryType,
          'basic_salary': model.basicSalary.toString(),
          'hra': model.hra.toString(),
          'pf': model.pf.toString(),
          'esi': model.esi.toString(),
          'professional_tax': model.professionalTax.toString(),
          'total_deductions': model.totalDeductions.toString(),
          'net_salary': model.netSalary.toString(),
          'ctc': model.ctc.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['status'] == true;
      }
      return false;
    } catch (e) {
      print('Error submitting salary structure: $e');
      return false;
    }
  }
} 