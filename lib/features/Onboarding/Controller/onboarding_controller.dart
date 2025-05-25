import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/onboarding_data.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final pageController = PageController();

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed('/UpgradePlanScreen');
    }
  }

  void skip() {
    Get.offAllNamed('/UpgradePlanScreen');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
