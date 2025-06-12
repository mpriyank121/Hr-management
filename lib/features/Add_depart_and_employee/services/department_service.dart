import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';

class DepartmentService {
  static Future<bool> submitDepartment({
    required String department,
    required String workType,
    required String supervisor,
    required String storedPhone,
    bool isEditing = false,
  }) async {
    final storedPhone = await SharedPrefHelper.getPhone();

    if (storedPhone == null || storedPhone.isEmpty) {
      print('Phone number not found in SharedPreferences.');
      return false;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    // Use different type code for edit vs create

    print('Submitting department:');
    print('- Department: $department');
    print('- Work Type: $workType');
    print('- Supervisor: $supervisor');
    print('- Is Editing: $isEditing');

    request.fields.addAll({
      'type': '90a93a93a61a94a105a90a107a109a102a94a103a109a105',
      'mob': EncryptionHelper.encryptString(storedPhone),
      'department': department,
      'work_type': workType,
      'supervisor': supervisor,
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response Body: ${response.body}');
      return data['status'] == true;
    } else {
      print('Server error: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> updateDepartment({
    required String department,
    required String workType,
    required String supervisor,
    required String storedPhone,
    required String departmentId,
  }) async {
    print('Updating department:');
    print('- Department ID: $departmentId');
    print('- Department Name: $department');
    print('- Work Type: $workType');
    print('- Supervisor: $supervisor');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '90a93a93a61a94a105a90a107a109a102a94a103a109a105',
      'mob': EncryptionHelper.encryptString(storedPhone),
      'department_id': departmentId,
      'department': department,
      'work_type': workType,
      'supervisor': supervisor,
      'action': 'update_department',
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Update Response: ${response.body}');
      return data['status'] == true;
    } else {
      print('Server error: ${response.statusCode}');
      return false;
    }
  }
}

Future<bool> editDepartment({
  required String department,
  required String workType,
  required String supervisor,
  required String storedPhone,
  required String editDepartment,
  required String departmentId,
  bool isEditing = false,
}) async {
  final storedPhone = await SharedPrefHelper.getPhone();

  if (storedPhone == null || storedPhone.isEmpty) {
    print('Phone number not found in SharedPreferences.');
    return false;
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
  );



  request.fields.addAll({
    'type': EncryptionHelper.encryptString(editDepartment),
    'id': EncryptionHelper.encryptString(departmentId),
    'department': (department),
    'work_type': workType,
    'supervisor': supervisor,
  });

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Response Body: ${response.body}');

    return data['status'] == true;
  } else {
    print('Server error: ${response.statusCode}');
    return false;
  }
}
