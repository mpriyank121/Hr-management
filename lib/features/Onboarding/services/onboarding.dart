import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/onboarding_page_model.dart';

class OnboardingService {
  static Future<List<OnboardingPageData>> fetchOnboardingPages() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '97a104a102a94a105',
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> dataList = jsonResponse['data'];
          return dataList
              .map((e) => OnboardingPageData.fromJson(e))
              .toList();
        } else {
          throw Exception('Invalid response or data not found');
        }
      } else {
        throw Exception('Failed to load onboarding data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching onboarding data: $e');
    }
  }
}
