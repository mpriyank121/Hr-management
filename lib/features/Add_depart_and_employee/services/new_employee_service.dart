import 'dart:convert';
import 'dart:io';
import 'package:hr_management/features/Employees/models/employee_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/fetchemployeedetail.dart';
import '../models/new_employee_model.dart';

class NewEmployeeService {
  static Future<bool> submitEmployee(NewEmployeeModel employee) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': "91a94a94a63a103a106a102a105a115a95a95a104",
        'mob': EncryptionHelper.encryptString(storedPhone!),
        'emp_name': employee.empName,
        'phone': employee.phone,
        'email': employee.email,
        'department': employee.departmentId,
        'gender': employee.gender,
        'position': employee.positionId,
        'emp_code': employee.EmployeeCode,
        'emp_type': employee.empTypeId,
        'doj': ?employee.date,
      "user_role": ?employee.UserRoleId,
      });

      if (employee.panFilePath != null && File(employee.panFilePath!).existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath('pan_image', employee.panFilePath!),
        );
      }
      if (employee.profilePath != null && File(employee.profilePath!).existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath('profile', employee.profilePath!),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        print('[DEBUG] Response: $decoded');

        return decoded['status'] == true;
      } else {
        print('[ERROR] HTTP ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('[EXCEPTION] $e');
      return false;
    }
  }
  static Future<EmployeeDetailModel?> fetchEmployeeById(String empId) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();
      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
        body: {
          'type': "96a94a109a62a102a105a61a90a109a90a105", // Get employee details
          'mob': EncryptionHelper.encryptString(storedPhone!), // use actual phone if needed
          'emp_id':EncryptionHelper.encryptString(empId),
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('Decoded data: ${decoded['data']}');
        print('Type: ${decoded['data'].runtimeType}');

        if (decoded['status'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          if (data is List && data.isNotEmpty) {
            return EmployeeDetailModel.fromJson(data[0]);
          }
        }
      }
    } catch (e) {
      print('[EXCEPTION] $e');
    }
    return null;
  }


  static Future<bool> updateEmployee(NewEmployeeModel employee, String empId) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': "", // Update employee
        'mob': EncryptionHelper.encryptString(storedPhone!),
        'emp_id': empId,
        'emp_name': employee.empName,
        'phone': employee.phone,
        'email': employee.email,
        'department': employee.departmentId,
        'gender': employee.gender,
        'position': employee.positionId,
        'emp_code': employee.EmployeeCode,
        'emp_type': employee.empTypeId,
        'doj': employee.date ?? '',
        'user_role': employee.UserRoleId ?? '',
      });

      if (employee.panFilePath != null && File(employee.panFilePath!).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('pan', employee.panFilePath!));
      }
      if (employee.profilePath != null && File(employee.profilePath!).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('profile', employee.profilePath!));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        print('[DEBUG] Update Employee Response: $decoded');
        return decoded['status'] == true;
      } else {
        print('[ERROR] HTTP ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('[EXCEPTION] $e');
      return false;
    }
  }
}
