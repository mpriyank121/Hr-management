import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants/api_constants.dart';

class PlanService {
  final String baseUrl;

  PlanService({this.baseUrl = ApiConstants.plans});

  Future<Map<String, dynamic>?> sendRequest(Map<String, String> fields) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll(fields);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}
