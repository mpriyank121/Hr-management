import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/onboarding_page_model.dart';
import '../services/onboarding.dart';

class OnboardingController extends GetxController {
  final onboardingPages = <OnboardingPageData>[].obs;
  final currentPage = 0.obs;
  final isLoading = true.obs;
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    fetchOnboardingPages();
  }

  void fetchOnboardingPages() async {
    try {
      isLoading.value = true;
      onboardingPages.value = await OnboardingService.fetchOnboardingPages();
    } catch (e) {
      print('Error fetching onboarding data: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
}

