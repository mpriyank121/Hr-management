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
          await http.MultipartFile.fromPath('profile_image', employee.profilePath!),
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
      print('📱 Fetching employee details for ID: $empId');
      print('📱 Using phone: $storedPhone');

      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
        body: {
          'type': "96a94a109a62a102a105a61a90a109a90a105", // Get employee details
          'mob': EncryptionHelper.encryptString(storedPhone!),
          'emp_id': EncryptionHelper.encryptString(empId), // Encrypt the ID
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('📦 Decoded data: ${decoded['data']}');
        print('📦 Data type: ${decoded['data'].runtimeType}');

        if (decoded['status'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          if (data is List && data.isNotEmpty) {
            print('✅ Found employee data: ${data[0]}');
            final employeeData = data[0];
            // Ensure the ID is set correctly
            employeeData['emp_id'] = empId;
            return EmployeeDetailModel.fromJson(employeeData);
          } else {
            print('❌ No employee data found in response');
          }
        } else {
          print('❌ API returned error: ${decoded['message']}');
          }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 Error fetching employee details: $e');
    }
    return null;
  }

  static Future<bool> updateEmployee(
      NewEmployeeModel employee,
      String empId, {
        required bool isProfileChanged,
        required bool isPanCardChanged,
      }) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': EncryptionHelper.encryptString("editEmployee"),
        'mob': EncryptionHelper.encryptString(storedPhone ?? ''),
        'emp_id': EncryptionHelper.encryptString(empId),
        'emp_name': employee.empName,
        'emp_phone': employee.phone,
        'emp_email': employee.email,
        'department': employee.departmentId,
        'gender': employee.gender,
        'position': employee.positionId,
        'emp_code': employee.EmployeeCode,
        'emp_type': employee.empTypeId,
        'doj': employee.date ?? '',
        'user_role': employee.UserRoleId ?? '',
        'isprofilechange': isProfileChanged.toString(),
        'ispanchange': isPanCardChanged.toString(),
      });

      print('Updating employee:');
      print('emp_id: $empId');
      print('department: ${employee.departmentId}');
      print('All fields: \\n${request.fields}');

      // Add PAN image file if changed
      if (isPanCardChanged &&
          employee.panFilePath != null &&
          File(employee.panFilePath!).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'pan_image',
          employee.panFilePath!,
        ));
      }

      // Add profile image file if changed
      if (isProfileChanged &&
          employee.profilePath != null &&
          File(employee.profilePath!).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          employee.profilePath!,
        ));
      }

      print('🔄 Submitting employee update...');
      print('Fields: ${request.fields}');
      print('Files: PAN - ${employee.panFilePath}, Profile - ${employee.profilePath}');

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        print('Update response: $decoded');
        print('[✅] Update Employee Response: $decoded');
        return decoded['status'] == true;
      } else {
        print('[❌] HTTP ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('[🚨 EXCEPTION] $e');
      return false;
    }
  }

}
