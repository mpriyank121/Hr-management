import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/organization_service.dart';
import '../models/organization_model.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

class OrganizationController extends GetxController {
  var organization = Rxn<OrganizationModel>();
  var isLoading = false.obs;

  Future<void> loadOrganization(String phone) async {
    try {
      isLoading.value = true;
      final data = await OrganizationService.fetchOrganizationByPhone();
      organization.value = data;
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
