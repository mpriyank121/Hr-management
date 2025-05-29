import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';

class DepartmentService {
  static Future<bool> submitDepartment({
    required String department,
    required String workType,
    required String supervisor, required String storedPhone,
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
}
