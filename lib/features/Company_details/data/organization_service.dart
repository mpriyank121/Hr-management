import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../models/organization_model.dart';

class OrganizationService {
  static Future<OrganizationModel?> fetchOrganizationByPhone() async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');

    if (storedPhone == null || storedPhone.isEmpty) {
      print('⚠️ Phone number not found in SharedPreferences.');
      return null;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '103a106a95a65a102a94a103a106',
      'mob': EncryptionHelper.encryptString(storedPhone),
    });

    print('🚀 Sending Organization Fetch Request...');
    print('Request Fields: ${request.fields}');

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        print('✅ Response Body: $responseBody');

        final jsonResponse = jsonDecode(responseBody);
        print('📦 Decoded JSON: $jsonResponse');

        final data = jsonResponse['data'];

        if (jsonResponse['status'] == true && data is List && data.isNotEmpty) {
          print('🏢 Organization found!');
          return OrganizationModel.fromJson(data[0]);
        } else {
          print('❌ Organization data is empty or not found');
          return null;
        }
      } else {
        print('❗️Failed with status code: ${streamedResponse.statusCode}');
        throw Exception('Failed to fetch organization');
      }
    } catch (e) {
      print('🚨 Exception in fetching organization: $e');
      return null;
    }
  }
}
