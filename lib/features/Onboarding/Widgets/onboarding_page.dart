import 'package:flutter/material.dart';
import '../../../config/style.dart';
import '../../../core/widgets/primary_button.dart';
import 'onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return Stack(
      children: [
        // Image part
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
                stops: [0.8, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child:Center(child:Image.asset(
              data.image,
              height: screenHeight *0.8,
              width: screenWidth * 0.7
            ),)
          ),
        ),

        // Bottom clipped container
        Positioned(
          top: screenHeight * 0.45, // slight overlap to make image go into the container
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipPath(
            clipper: InvertedTopCurveClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), // offset from curve dip
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      final isActive = index == currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.deepOrange
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  currentPage == totalPages - 1
                      ? Center(
                    child: PrimaryButton(
                      onPressed: onNext,
                      widthFactor: 0.8,
                      heightFactor: 0.06,
                      text: "Continue",
                    ),
                  )
                      : Row(
                    children: [
                      PrimaryButton(
                        textColor: const Color(0xFFF25922),
                        buttonColor: const Color(0x19CD0909),
                        widthFactor: 0.4,
                        heightFactor: 0.06,
                        text: "Skip",
                        onPressed: onSkip,
                      ),
                      const SizedBox(width: 10),
                      PrimaryButton(
                        onPressed: onNext,
                        widthFactor: 0.4,
                        heightFactor: 0.06,
                        text: "Next",
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
