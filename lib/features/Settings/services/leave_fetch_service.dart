import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../../config/app_constants.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/apply_leave_model.dart';
import '../models/fetch_org_leave.dart';
import '../models/leave_type_model.dart';

class LeaveService {
  Future<List<LeaveTypeModel>> fetchLeaveTypes() async {
    var request = MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php'),
    );

    request.fields.addAll({
      'type': '107a100a96a117a100a83a120a111a100a99',
    });

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonData = json.decode(responseBody);
      final List data = jsonData['data'];
      return data.map((e) => LeaveTypeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load leave types');
    }
  }
  Future<String> submitLeaves({
    required String mob,
    required String type,
    required List<LeaveTypeModel> leaveTypes,
    required List<String> leaveCounts,
  }) async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');

    final Uri url = Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php');
    var request = MultipartRequest('POST', url);

    request.fields['type'] = "91a94a94a70a95a91a112a95a78a115a106a95a104";
    request.fields['mob'] = EncryptionHelper.encryptString(storedPhone!);
    print('📤 Submitting leave config...');
    print('➡️ type: ${request.fields['type']}');
    print('➡️ mob: $storedPhone');

    for (int i = 0; i < leaveTypes.length; i++) {
      request.fields['leaveType[$i]'] = leaveTypes[i].id;
      request.fields['annual_leave[$i]'] = leaveCounts[i];
      print('🔁 Adding leaveType[$i] = ${leaveTypes[i].id}, annual_leave[$i] = ${leaveCounts[i]}');
    }

    print('🧾 Final request fields:');
    request.fields.forEach((key, value) {
      print('  $key => $value');
    });

    try {
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('📨 Response Body: $responseBody');

      final decoded = json.decode(responseBody);

      if (decoded['success'] == 'success') {
        print('✅ Leave submission successful');
        return decoded['message'] ?? 'Success';
      } else {
        print('⚠️ Leave submission failed: ${decoded['message']}');
        throw Exception(decoded['message'] ?? 'Failed to submit leaves');
      }
    } catch (e) {
      print('❌ Error occurred while submitting leave: $e');
      rethrow;
    }
  }
  static Future<List<OrgLeave>?> fetchorgleaves() async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php'),
    );

    request.fields.addAll({
      'type': '99a97a112a75a110a99a72a97a93a114a97a102',
      'mob': EncryptionHelper.encryptString(storedPhone!),
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('✅ Response Body: $responseBody');

        final Map<String, dynamic> jsonMap = jsonDecode(responseBody);

        if (jsonMap['status'] == true && jsonMap['data'] is List) {
          final dataList = jsonMap['data'] as List;

          List<OrgLeave> leaves = dataList
              .map((item) => OrgLeave.fromJson(item))
              .toList();

          print('✅ Parsed ${leaves.length} leave types');
          return leaves;
        } else {
          print('⚠️ Invalid response structure or no leave data.');
          return null;
        }
      } else {
        print('❌ Error Response: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('❗ Exception while fetching leave types: $e');
      return null;
    }
  }
  static Future<Map<String, dynamic>?> applyLeave(ApplyLeaveRequest request) async {
    try {
      var uri = Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php');
      var httpRequest = http.MultipartRequest('POST', uri);

      // Add fields from the ApplyLeaveRequest model
      httpRequest.fields.addAll(request.toMap());

      var response = await httpRequest.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonMap = jsonDecode(responseBody);

        // Assuming API response contains at least 'status' and 'message'
        bool status = jsonMap['status'] ?? false;
        String message = jsonMap['message'] ?? 'No message';

        return {
          'status': status,
          'message': message,
        };
      } else {
        print('Apply Leave Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception in applyLeave: $e');
      return null;
    }
  }
}




