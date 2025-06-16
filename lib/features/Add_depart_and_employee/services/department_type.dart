import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/department_type_model.dart';

class DepartmentTypeService {
  static Future<List<DepartmentModel>> fetchDepartmenttypes({
    required String department,
  }) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();
      if (storedPhone == null || storedPhone.isEmpty) {
        print('[ERROR] Phone number not found in SharedPreferences.');
        throw Exception('Phone number not found in SharedPreferences.');
      }
      final encryptedType = EncryptionHelper.encryptString(department);
      final url = Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php');
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'type': encryptedType,
        'mob': EncryptionHelper.encryptString(storedPhone),
      });
      final response = await request.send();
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final decoded = json.decode(body);
        if (decoded['status'] == true) {
          final List departments = decoded['data'];
          return departments.map((e) => DepartmentModel.fromJson(e)).toList();
        } else {
          throw Exception(decoded['message'] ?? 'Failed to fetch departments');
        }
      } else {
        throw Exception('Network error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('[ERROR] Exception while fetching departments: $e');
      return [];
    }
  }
}
