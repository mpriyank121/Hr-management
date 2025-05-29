import 'package:get/get.dart';
import '../data/organization_service.dart';
import '../models/organization_model.dart';

class OrganizationController extends GetxController {
  var organization = Rxn<OrganizationModel>();
  var isLoading = false.obs;

  Future<void> loadOrganization(String phone) async {
    try {
      isLoading.value = true;
      final data = await OrganizationService.fetchOrganizationByPhone();
      organization.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
