import 'package:get/get.dart';
import '../Widgets/onboarding_data.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      currentPage.value++;
    } else {
      Get.offAllNamed('/UpgradePlanScreen');
    }
  }

  void skip() {
    Get.offAllNamed('/UpgradePlanScreen');
  }
}
