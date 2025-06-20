import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../model/clock_in_model.dart';

class ClockInService {
  static Future<Map<String, List<ClockInModel>>> fetchAttendanceStatus() async {
    final storedPhone = await SharedPrefHelper.getPhone();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php'),
    );
    request.fields.addAll({
      'type': '94a92a107a60a100a103a56a107a107a92a101a91a88a101a90a92a59a88a107a88a107',
      'mob': EncryptionHelper.encryptString(storedPhone!),
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      print("qaz$data");
      final decoded = jsonDecode(data) as Map<String, dynamic>;

      // Helper function to safely convert to list
      List<ClockInModel> _safeConvertToList(dynamic data, String fieldName) {
        if (data == null) {
          print("Warning: $fieldName is null");
          return <ClockInModel>[];
        }

        if (data is List) {
          return data.map((e) => ClockInModel.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is Map) {
          print("Warning: $fieldName is a Map instead of List: $data");
          // If it's a single object, wrap it in a list
          return [ClockInModel.fromJson(data as Map<String, dynamic>)];
        } else {
          print("Warning: $fieldName has unexpected type: ${data.runtimeType}");
          return <ClockInModel>[];
        }
      }

      return {
        'checkIN': _safeConvertToList(decoded['checkIN'], 'checkIN'),
        'notcheckIN': _safeConvertToList(decoded['notcheckIN'], 'notcheckIN'),
        'emp_on_leave': _safeConvertToList(decoded['emp_on_leave'], 'emp_on_leave'),
      };
    } else {
      throw Exception('Failed to fetch attendance: ${response.reasonPhrase}');
    }
  }
}