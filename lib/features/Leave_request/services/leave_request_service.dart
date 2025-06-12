import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../models/LeaveRequestModel.dart';


class LeaveRequestService {
  static Future<List<LeaveRequestModel>> fetchLeaveRequests() async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php'),
    );

    request.fields.addAll({
      'type': '102a100a115a68a108a111a75a100a96a117a100a99',
      'mob': EncryptionHelper.encryptString(storedPhone!),
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);

      if (data['status'] == true && data['data'] != null) {
        print("qwer: $data");
        return (data['data'] as List)
            .map((e) => LeaveRequestModel.fromJson(e))
            .toList();

      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception(response.reasonPhrase ?? "Unknown error");
    }
  }
}
