import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/style.dart';
import '../../core/widgets/primary_button.dart';
import 'Widgets/onboarding_data.dart';
import 'Widgets/onboarding_page.dart';
import 'Controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background painter
            Container(
              color: const Color(0xFFF79C7B),
              child: CustomPaint(
                size: MediaQuery.of(context).size,
                painter: TripleOrangeWavePainter(),
              ),
            ),

            // Foreground content
            Column(
              children: [
                // Onboarding pages
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: onboardingPages.length,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        data: onboardingPages[index],
                        currentPage: controller.currentPage.value,
                        totalPages: onboardingPages.length,
                        onNext: controller.nextPage,
                        onSkip: controller.skip,
                      );
                    },
                  ),
                ),

                // Bottom static UI

              ],
            ),
            Positioned(
              bottom: 0,
              child: Obx(() {
              final isLastPage = controller.currentPage.value == onboardingPages.length - 1;
              return Column(
                children: [
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingPages.length, (index) {
                      final isActive = index == controller.currentPage.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.deepOrange : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: isLastPage
                        ? PrimaryButton(
                      onPressed: controller.nextPage,
                      widthFactor: 0.8,
                      heightFactor: 0.06,
                      text: "Continue",
                    )
                        : Row(
                      children: [
                        PrimaryButton(
                          textColor: const Color(0xFFF25922),
                          buttonColor: const Color(0x19CD0909),
                          widthFactor: 0.4,
                          heightFactor: 0.06,
                          text: "Skip",
                          onPressed: controller.skip,
                        ),
                        const SizedBox(width: 10),
                        PrimaryButton(
                          onPressed: controller.nextPage,
                          widthFactor: 0.4,
                          heightFactor: 0.06,
                          text: "Next",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }),)
          ],
          
        ),
      ),
    );
  }
}
