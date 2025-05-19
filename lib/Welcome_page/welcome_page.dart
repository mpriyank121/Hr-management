import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_management/login/login_screen.dart';
import 'package:hr_management/widgets/primary_button.dart';

import '../Configuration/app_buttons.dart';
import '../Onboarding/onboarding_screen.dart';
import '../widgets/Custom_background.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // You can replace this with your actual logo widget/image
    Widget logo = Container(
      width: 30,
      height: 30,

      child: SvgPicture.asset('assets/images/bc 3.svg'),
    );

    // Menu item widget
    Widget menuItem(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 26),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(
            imagePath: 'assets/images/background_image.png',
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and logo row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bookchor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      logo, // your logo widget
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  const Text(
                    "HR Managements App",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.18), // relative spacing

                  // White card with menu items, width relative to screen size
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // 80% of screen width
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
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

                  // Bottom buttons, full width with padding
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(text: "Create Company Account",
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnboardingScreen(),
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
                              builder: (context) => LoginScreen(),
                            ),
                          );                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: PrimaryButtonConfig.color,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Join Existing Company",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: PrimaryButtonConfig.color,
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
