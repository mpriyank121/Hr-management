import 'dart:convert';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php';

  /// Send OTP to a phone number (already encoded)
  static Future<Map<String, dynamic>> sendOtp(String Phone) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.fields.addAll({
      'type': '109a95a104a94a73a110a106a104', // Type for sending OTP
      'phone': EncryptionHelper.encryptString(Phone),
    });

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Send OTP failed: ${response.reasonPhrase}');
    }
  }

  /// Verify OTP with phone and otp (all encoded if required)
  static Future<Map<String, dynamic>> verifyOtp(String Phone, String otp) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.fields.addAll({
      'type': '107a112a108a82a97a110a101a98a101a95a93a112a101a107a106a102', // Replace with the actual verification type
      'phone': EncryptionHelper.encryptString(Phone),
      'otp': EncryptionHelper.encryptString(otp),
    });

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Verify OTP failed: ${response.reasonPhrase}');
    }
  }
  /// Fetch city and state from encoded pincode
}
