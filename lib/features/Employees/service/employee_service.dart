import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Employees/models/employee_model.dart';

class EmployeeService {
  static Future<List<Employee>> fetchEmployees() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      request.fields.addAll({
        'type': '98a96a111a64a104a107a63a96a107a92a109a111a104a96a105a111a114a100a110a96a103',
        'mob': '52a46a44a44a45a51a52a48a45a45a103',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        final Map<String, dynamic> data = jsonDecode(resString);

        if (data['status'] == true && data['data'] is List) {
          return (data['data'] as List)
              .map<Employee>((e) => Employee.fromJson(e))
              .toList();
        } else {
          throw Exception("Invalid data format or status false");
        }
      } else {
        throw Exception('Failed to load employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching employees: $e');
    }
  }
}
