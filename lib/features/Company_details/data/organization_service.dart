import 'dart:convert';
import 'dart:io';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/shared_pref_helper_class.dart';
import '../models/organization_model.dart';
import 'package:path/path.dart';


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
          return OrganizationModel.toJson(data[0]);
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
  static Future<bool> updateOrganization({
    required Map<String, dynamic> data,
    File? orgLogo,
    File? panImage,
    required bool isProfileChanged,
    required bool isPanCardChanged,
  }) async {
    final storedPhone = await SharedPrefHelper.getPhone();
    if (storedPhone == null || storedPhone.isEmpty) {
      print('⚠️ Phone number not found in SharedPreferences.');
      return false;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': EncryptionHelper.encryptString('editOrganization'), //
      'mob': EncryptionHelper.encryptString(storedPhone),
      'islogochange': isProfileChanged.toString(),
      'ispanchange': isPanCardChanged.toString(),
    });

    // Add organization text fields
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    // Add org logo file
    if (orgLogo != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'org_logo',
        orgLogo.path,
        filename: basename(orgLogo.path),
      ));
    }

    // Add PAN image file
    if (panImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'pan_image',
        panImage.path,
        filename: basename(panImage.path),
      ));
    }

    print('🚀 Sending Update Request...');
    print('Fields: ${request.fields}');
    print('Files: Logo - ${orgLogo?.path}, PAN - ${panImage?.path}');

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('✅ Update Response: $responseBody');

        return responseBody['status'] == true;
      } else {
        print('❌ Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('🚨 Exception in updating organization: $e');
      return false;
    }
  }
}
