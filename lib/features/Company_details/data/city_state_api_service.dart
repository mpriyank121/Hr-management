import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/city_state_model.dart';

class LocationService {
  static Future<CityState?> fetchCityStateFromPincode(String pincode) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
    );

    request.fields.addAll({
      'type': '102a105a93a91a110a99a105a104a60a115a74a99a104a93a105a94a95a104',
      'pincode': pincode,
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return CityState.fromJson(data);
      } else {
        print('API Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
