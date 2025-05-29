import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../config/style.dart';
import '../../core/widgets/App_bar.dart';
import '../../core/widgets/primary_button.dart';
import 'controller/login_controller.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Bookchor',
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/bc 3.svg'),
            onPressed: () {},
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HR Management App', style: fontStyles.commonTextStyle),
              SizedBox(height: screenHeight * 0.02),

              Text('Enter Your Mobile Number', style: fontStyles.headingStyle),
              SizedBox(height: screenHeight * 0.015),

              Text(
                'Enter your mobile number to get started',
                style: fontStyles.commonTextStyle,
              ),
              SizedBox(height: screenHeight * 0.025),

              /// 📱 Phone Number Input Field
              TextField(
                controller: authController.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.03,
                      top: screenHeight * 0.015,
                    ),
                    child: Text('+91', style: fontStyles.headingStyle),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),

              const Spacer(),

              /// ✅ Continue Button
              PrimaryButton(
                text: 'Continue',
                onPressed: () async {
                  await authController.sendOtpToUser();

                  if (authController.isOtpSent.isTrue) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpPage(
                          phone: authController.phoneController.text.trim(),
                        ),
                      ),
                    );
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
