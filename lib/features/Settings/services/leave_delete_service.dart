import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;

class LeaveDeleteService {
  static Future<Map<String, dynamic>?> deleteLeave({
    required String type,
    required String id,
  }) async {
    final url = Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php');

    // Encrypt ID
    final encryptedId = EncryptionHelper.encryptString(id);

    // Log request data
    debugPrint('🔐 Sending delete request with:');
    debugPrint('Type: $type');
    debugPrint('Encrypted ID: $encryptedId');

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'type': "110a97a105a107a114a97a72a97a93a114a97a80a117a108a97a102",
      'id': encryptedId,
    });

    try {
      http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();

      debugPrint('📩 API Raw Response: $responseBody');

      final data = jsonDecode(responseBody);

      // Log parsed data
      debugPrint('✅ Parsed Response: $data');

      return data;
    } catch (e) {
      debugPrint('❌ Exception while deleting leave: $e');
      return {
        "status": false,
        "message": "Exception: $e",
      };
    }
  }
}
