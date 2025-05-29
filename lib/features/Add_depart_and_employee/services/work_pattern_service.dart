import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/work_pattern_model.dart';

class WorkPatternService {
  static Future<List<WorkPattern>> fetchWorkPatterns() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '115a107a110a103a112a117a108a97a102', // your API type param
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final List<dynamic> list = data['data'];
        return list.map((e) => WorkPattern.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load work patterns');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
