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
        throw Exception('Phone number not found in SharedPreferences.');
      }

      final encryptedType = EncryptionHelper.encryptString(department);

      print('[DEBUG] Raw Type: $department');
      print('[DEBUG] Encrypted Type: $encryptedType');
      print('[DEBUG] Encrypted Type: $storedPhone');

      final url = Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php');
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'type': encryptedType,
        'mob': EncryptionHelper.encryptString(storedPhone),
      });

      print('[DEBUG] Sending request to: $url');
      print('[DEBUG] Request Fields: ${request.fields}');

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        print('[DEBUG] Raw Response Body: $body');

        final decoded = json.decode(body);
        print('[DEBUG] Decoded Response: $decoded');

        if (decoded['status'] == true) {
          final List data = decoded['data'];
          print('[DEBUG] Department Data: $data');

          return data.map((e) => DepartmentModel.fromJson(e)).toList();
        } else {
          print('[DEBUG] API Error Message: ${decoded['message']}');
          throw Exception(decoded['message'] ?? 'Failed to fetch departments');
        }
      } else {
        throw Exception('Network error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('[ERROR] Exception while fetching departments: $e');
      return []; // Return empty list on failure
    }
  }
}
