import '../../../constants/api_constants.dart';
import '../../../core/services/base_api_service.dart';

class IndustryApiService extends BaseApiService {
  final String _url = (ApiConstants.registerCompany);

  Future<List<Map<String, dynamic>>> fetchIndustries() async {
    final response = await sendMultipartPost(
      url: _url,
      fields: {
        'type': '102a107a97a114a112a113a111a118a81a118a109a98a101',
      },
    );

    if (response['status'] == true && response['data'] != null) {
      return List<Map<String, dynamic>>.from(response['data']);
    }

    return [];
  }
}
