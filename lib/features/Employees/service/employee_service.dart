import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../../Employees/models/employee_model.dart';

class EmployeeService {
  /// 📥 Fetch all employees
  static Future<List<Employee>> fetchEmployees() async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': '98a96a111a64a104a107a63a96a107a92a109a111a104a96a105a111a114a100a110a96a103',
        'mob': EncryptionHelper.encryptString(storedPhone!),
      });

      http.StreamedResponse response = await request.send();
      final resString = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(resString);

      if (data['status'] == true && data['data'] is List) {
        print("qwertr: ${data}");
        return (data['data'] as List)
            .map<Employee>((e) => Employee.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to fetch employees: ${data['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      throw Exception('Error fetching employees: $e');
    }
  }

  /// 📄 Fetch individual employee details
  static Future<bool> fetchemployeedata(Employee employee) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();
      print('📞 Phone from SharedPreferences: $storedPhone');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': EncryptionHelper.encryptString('getEmpData'),
        'emp_id': EncryptionHelper.encryptString(employee.id),
        'mob': EncryptionHelper.encryptString(storedPhone!),
      });

      http.StreamedResponse response = await request.send();
      final resString = await response.stream.bytesToString();
      final data = jsonDecode(resString);


      return data['status'] == true;

    } catch (e) {
      throw Exception('Error fetching employee data: $e');
    }
  }

}
