import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;

import '../../../core/shared_pref_helper_class.dart';

class HolidayAddService {

  static Future<http.StreamedResponse> addHoliday({
    required String holiday,
    required String holidayDate,
    required String year,

  }) async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('📞 Phone from SharedPreferences: $storedPhone');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '95a98a98a70a109a106a103a98a95a119a100',
      'mob': EncryptionHelper.encryptString(storedPhone!),
      'holiday': holiday,
      'holiday_date': holidayDate,
      'year': year,
    });

    return await request.send();
  }
  static Future<http.StreamedResponse> editHoliday({
    required String holiday,
    required String holidayDate,
    required String year,
    required String id,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );

    request.fields.addAll({
      'type': '92a91a96a107a63a102a99a96a91a88a112a107',
      'id': EncryptionHelper.encryptString(id),
      'holiday': holiday,
      'holiday_date': holidayDate,
      'year': year,
    });

    return await request.send();
  }
  static Future<http.StreamedResponse> deleteHoliday({
    required String id,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php'),
    );
    request.fields.addAll({
      'type': '112a99a107a109a116a99a70a109a106a103a98a95a119a100',
      'id': EncryptionHelper.encryptString(id),

    });
    return await request.send();
  }
}
