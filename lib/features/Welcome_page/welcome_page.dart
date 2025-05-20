import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/app_buttons.dart';
import '../../config/font_style.dart';
import '../../core/widgets/Custom_background.dart';
import '../../core/widgets/primary_button.dart';
import '../Onboarding/onboarding_screen.dart';
import '../login/login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Widget logo = SvgPicture.asset(
      'assets/images/bc 3.svg',
      width: 30,
      height: 30,
    );

    Widget menuItem(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: FontStyles.subHeadingStyle(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(
            imagePath: 'assets/images/background_image.png',
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Logo
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bookchor",
                        style: FontStyles.headingStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 8),
                      logo,
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "HR Managements App",
                    style: FontStyles.subTextStyle(fontSize: 12),
                  ),

                  SizedBox(height: screenHeight * 0.18),

                  // Info Card
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            menuItem(Icons.calendar_today_outlined, "Attendance"),
                            menuItem(Icons.payment_outlined, "Payment slip"),
                            menuItem(Icons.manage_accounts_outlined, "Manage Leaves"),
                            menuItem(Icons.location_on_outlined, "Live Tracking"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        text: "Create Company Account",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  LoginScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: PrimaryButtonConfig.color),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Join Existing Company",
                          style: FontStyles.subHeadingStyle(
                            color: PrimaryButtonConfig.color,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
