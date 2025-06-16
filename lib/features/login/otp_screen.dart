import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../config/style.dart';
import '../../core/widgets/Nav_bar.dart';
import '../../core/widgets/Resend_button.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/Custom_background.dart';
import 'Widgets/Otp_text_field.dart';
import 'controller/login_controller.dart';

class OtpPage extends StatelessWidget {
  final String phone;

  OtpPage({Key? key, required this.phone}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          /// 🖼 Background Image
          const CustomBackground(
            imagePath: 'assets/images/background_image.png',
          ),

          /// 🔒 OTP Form
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  Text(
                    'Enter the verification code sent to',
                    style: fontStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    '+91 $phone',
                    style: fontStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Enter your OTP to continue',
                    style: fontStyles.subTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  /// 🔢 OTP Field
                  OtpTextField(
                    onOtpComplete: (otp) {
                      _authController.otpController.text = otp;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  /// 🔁 Resend OTP Button
                  ResendButton(
                    onResend: () => _authController.sendOtpToUser(),

                  ),

                  const Spacer(),

                  /// ✅ Continue Button
                  Obx(() => PrimaryButton(
                    text: _authController.isLoading.value
                        ? 'Verifying...'
                        : 'Continue',
                    icon: _authController.isLoading.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : SvgPicture.asset("assets/images/Arrow_Circle_Right.svg"),
                    onPressed: _authController.isLoading.value
                        ? null
                        : () async {
                      await _authController.verifyUserOtp();
                      if (_authController.isPhoneVerified.isTrue) {
                        Get.offAll(() => MainScreen());
                      }
                    },
                  )),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
