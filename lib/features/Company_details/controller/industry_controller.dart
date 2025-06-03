import 'package:get/get.dart';
import 'package:hr_management/core/widgets/app_toast.dart';
import '../data/industry_api_service.dart';
import '../models/industry_model.dart';

class IndustryController extends GetxController {
  var industries = <Industry>[].obs;
  var isLoading = false.obs;

  final _apiService = IndustryApiService();

  void fetchIndustries() async {
    try {
      isLoading.value = true;
      final data = await _apiService.fetchIndustries();
      industries.value = data.map((json) => Industry.fromJson(json)).toList();
    } catch (e) {
      AppToast.show(message: 'Error'  );
    } finally {
      isLoading.value = false;
    }
  }
}
