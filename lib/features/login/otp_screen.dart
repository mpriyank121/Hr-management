import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/style.dart';
import '../../core/widgets/Nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import 'Widgets/Otp_text_field.dart';
import 'controller/login_controller.dart';

class OtpPage extends StatelessWidget {
  final String phone;

  OtpPage({Key? key, required this.phone}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              /// ✅ OTP Input Field

                OtpTextField(
                  onOtpComplete: (otp) {
                    _authController.otpController.text = otp;
                  },
                ),
              SizedBox(height: screenHeight * 0.03),

              /// 🔁 Resend OTP Button
              TextButton(
                onPressed: () => _authController.sendOtpToUser(),
                child: const Text("Resend OTP"),
              ),

              const Spacer(),

              /// ✅ Continue Button
              PrimaryButton(
                text: 'Continue',
                onPressed: () async {
                  await _authController.verifyUserOtp();

                  if (_authController.isPhoneVerified.isTrue) {
                    Get.offAll(() => MainScreen());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
