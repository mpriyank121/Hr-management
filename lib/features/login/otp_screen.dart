import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/style.dart';
import '../../core/widgets/Nav_bar.dart';
import '../../core/widgets/primary_button.dart';

class OtpPage extends StatelessWidget {
  final String phone; // ✅ Accept phone as a parameter

  OtpPage({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter the verification code sent to', style: fontStyles.headingStyle, textAlign: TextAlign.center),
            SizedBox(height: screenHeight * 0.01),
            Text(phone, style: fontStyles.headingStyle, textAlign: TextAlign.center), // ✅ Display phone number
            SizedBox(height: screenHeight * 0.01),
            Text('Enter your OTP to continue', style: fontStyles.subTextStyle, textAlign: TextAlign.center),
            SizedBox(height: screenHeight * 0.03),

            /// ✅ OTP Input Field
            //OtpTextField(onOtpComplete: (otp) => _authController.verifyOtp(phone, otp)),

            SizedBox(height: screenHeight * 0.03),

            /// ✅ Resend OTP Button
           // ResendButton(onResend: () => _authController.sendOtp(phone)),

            /// ✅ Verify Button
            Spacer(),
            PrimaryButton(

                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                }, text: 'Continue',
            ),
          ],
        ),
      ),
    ));
  }
}
