import 'dart:convert';
import 'package:http/http.dart' as http;

class JobTypeService {
  static const String url = 'https://apis-stg.bookchor.com/webservices/hrms/v1/home.php';


  static Future<Map<String, dynamic>> fetchJobTypes() async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({'type': '97a105a108a91a112a117a108a97a102'});

    try {
      http.StreamedResponse response = await request.send();
      final responseString = await response.stream.bytesToString(); // Correct stream usage
      final decoded = jsonDecode(responseString);

      if (response.statusCode == 200 && decoded['status'] == true) {
        return decoded;
      } else {
        throw Exception("Failed to fetch home data: ${decoded['message'] ?? response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error fetching home data: $e");
    }
  }
}
