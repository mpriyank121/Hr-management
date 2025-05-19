import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Configuration/style.dart';
import 'Widgets/onboarding_data.dart';
import 'Widgets/onboarding_page.dart';
import 'Controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
            Container(
              color:  Color(0xFFF79C7B),
              child:
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: TripleOrangeWavePainter(),
            ),)   ,

          // Foreground content
          Obx(() {
            final data = onboardingPages[controller.currentPage.value];
            return OnboardingPage(
              data: data,
              currentPage: controller.currentPage.value,
              totalPages: onboardingPages.length,
              onNext: controller.nextPage,
              onSkip: controller.skip,
            );
          }),
        ],
      ),
    );
  }
  }
