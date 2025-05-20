import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseApiService {
  Future<dynamic> sendMultipartPost({
    required String url,
    required Map<String, String> fields,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(fields);

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return json.decode(body);
    } else {
      throw Exception("HTTP error: ${response.statusCode}");
    }
  }
}
