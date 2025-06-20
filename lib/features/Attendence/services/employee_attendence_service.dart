import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/employee_attendance_model.dart';

class AttendanceService {
  static Future<List<AttendanceModel>> fetchAttendance({
    required String type,
    required String mob,
    required String startDate,
    required String endDate,
    required String id,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php'),
    );

    request.fields.addAll({
      'type': type,
      'mob': mob,
      'start_date': startDate,
      'end_date': endDate,
      'id': id,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      final jsonResponse = json.decode(jsonString);
      if (jsonResponse['status'] == true) {
        List data = jsonResponse['data'];
        return data.map((e) => AttendanceModel.fromJson(e)).toList();
      } else {
        throw Exception(jsonResponse['message'] ?? 'Something went wrong');
      }
    } else {
      throw Exception('Failed to fetch attendance');
    }
  }
}
