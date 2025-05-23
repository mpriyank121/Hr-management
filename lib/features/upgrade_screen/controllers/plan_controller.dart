import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/plan_api_service.dart';
import '../model/plan_model.dart';

class PlanController extends GetxController {
  var plans = <Plan>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final PlanService apiService;

  PlanController({required this.apiService});

  Future<void> fetchPlans() async {
    isLoading.value = true;
    errorMessage.value = ''; // Reset error message
    try {
      var response = await apiService.sendRequest({
        'type': '104a100a89a102a107a60a93a108a89a97a100a107a106',
      });

      if (response != null && response['plans'] != null) {
        var plansData = response['plans'] as List;
        plans.value = plansData.map((planJson) => Plan.fromJson(planJson)).toList();
      } else {
        errorMessage.value = 'No plans available.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load plans: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
