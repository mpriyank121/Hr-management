import 'package:http/http.dart' as http;

class HolidayAddService {
  static Future<http.StreamedResponse> addHoliday({
    required String holiday,
    required String holidayDate,
    required String year,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '95a98a98a70a109a106a103a98a95a119a100',
      'mob': '48a42a40a40a41a47a48a44a41a41a107',
      'holiday': holiday,
      'holiday_date': holidayDate,
      'year': year,
    });

    return await request.send();
  }
}
