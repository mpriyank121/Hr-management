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
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php'),
        body: {
          'type': ("93a96a96a65a105a108a79a93a104a93a110a117a102"),
          'mob': EncryptionHelper.encryptString(storedPhone ?? ''),
          'emp_code': EncryptionHelper.encryptString(model.employeeCode),
           'other_pay': model.otherAllowances.toString(),
          'salary_type': model.salaryType,
          'basic_pay': model.basicSalary.toString(),
          'pf': model.pf.toString(),
          'esic': model.esi.toString(),
          'hra': model.hra.toString(),
          'total_deductions': model.totalDeductions.toString(),
          'net_amount': model.netSalary.toString(),
          'ctc': model.ctc.toString(),
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = jsonDecode(response.body);
        return responseBody['status'] == true;
      }
      return false;
    } catch (e) {
      print('Error submitting salary structure: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchEmployeeSalaryDetails(String employeeCode) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();

      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php'),
        body: {
          'type': ("98a96a111a64a104a107a78a92a103a92a109a116a103"),
          'mob': EncryptionHelper.encryptString(storedPhone ?? ''),
          'emp_code': EncryptionHelper.encryptString(employeeCode),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        if (responseBody['status'] == true && responseBody['data'] is List) {
          // Get the first item from the list if it exists
          final List<dynamic> dataList = responseBody['data'];
          if (dataList.isNotEmpty) {
            return dataList[0] as Map<String, dynamic>;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching salary details: $e');
      return null;
    }
  }
} 