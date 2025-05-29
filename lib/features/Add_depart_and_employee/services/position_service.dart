import 'dart:convert';
import 'package:http/http.dart' as http;

class PositionService {
  static const String _url = 'https://apis-stg.bookchor.com/webservices/hrms/v1/home.php';
  static const String _type = '97a105a108a91a108a107a111a112a101a107a106a102'; // Replace with actual encrypted key

  static Future<List<Map<String, dynamic>>> fetchPositions() async {
    var request = http.MultipartRequest('POST', Uri.parse(_url));
    request.fields.addAll({'type': _type});

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    final decoded = jsonDecode(responseString);

    if (decoded['status'] == true && decoded['data'] is List) {
      return List<Map<String, dynamic>>.from(decoded['data']);
    } else {
      throw Exception('Failed to fetch positions');
    }
  }
}
