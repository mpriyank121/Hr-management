import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/holiday_list_model.dart';
class HolidayService {
  static Future<List<Holiday>> fetchHolidays({required String year}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '100a98a113a69a108a105a102a97a94a118a101', // encrypted 'getHolidayList'
      'mob': '48a42a40a40a41a47a48a44a41a41a107',         // encrypted mobile
      'year': year,
    });

    try {
      http.StreamedResponse response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(body);
        if (decoded['status'] == true && decoded['data'] != null) {
          return List<Holiday>.from(decoded['data'].map((e) => Holiday.fromJson(e)));
        } else {
          return [];
        }
      } else {
        print('[ERROR] Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('[EXCEPTION] $e');
      return [];
    }
  }
}
