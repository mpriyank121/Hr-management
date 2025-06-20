import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../../Employees/models/employee_model.dart';
import 'package:intl/intl.dart';

class EmployeeService {
  /// 📥 Fetch all employees (assigned and unassigned)
  static Future<Map<String, dynamic>> fetchEmployees({DateTime? startDate, DateTime? endDate}) async {
    try {
      final storedPhone = await SharedPrefHelper.getPhone();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
      );

      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd');
      final start = startDate ?? DateTime(now.year, now.month, 1);
      final end = endDate ?? DateTime(now.year, now.month + 1, 0);

      request.fields.addAll({
        'type': '98a96a111a64a104a107a63a96a107a92a109a111a104a96a105a111a114a100a110a96a103',
        'mob': EncryptionHelper.encryptString(storedPhone!),
        'start_date': dateFormat.format(start),
        'end_date': dateFormat.format(end),
      });

      http.StreamedResponse response = await request.send();
      final resString = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(resString);

      if (data['status'] == true) {
        print("$response");
        final assigned = (data['data'] as List?)
            ?.map<Employee>((e) => Employee.fromJson(e))
            .toList() ??
            [];
        final unassigned = (data['notassignemp'] as List?)
            ?.map<Employee>((e) => Employee.fromJson(e))
            .toList() ??
            [];
        final totalWorking = data['total_working'];
        if (totalWorking != null && totalWorking['hrs'] != null) {
          final totalWorkingHours = totalWorking['hrs'].toString();
          print(data);

          return {
            'assigned': assigned,
            'unassigned': unassigned,
            'total_working': totalWorking,
          };
        } else {
          throw Exception("Failed to fetch employees: total_working is null or hrs is null");
        }
      } else {
        throw Exception("Failed to fetch employees: ${data['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      throw Exception('Error fetching employees: $e');
    }
  }
}

