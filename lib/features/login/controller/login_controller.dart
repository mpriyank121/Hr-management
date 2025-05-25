import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/services/auth_service.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final isOtpSent = false.obs;
  final isPhoneVerified = false.obs;

  /// Send OTP
  Future<void> sendOtpToUser() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar("Error", "Please enter phone number",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final response = await LoginAuthService.sendOtp(phone);
      if (response['status'] == true) {
        isOtpSent.value = true;
        isPhoneVerified.value = false;

        Get.snackbar("Success", response['message'] ?? "OTP sent",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to send OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Verify OTP
  Future<void> verifyUserOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "Enter OTP",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final response = await LoginAuthService.verifyOtp(phone, otp);
      if (response['success'] == true) {
        isPhoneVerified.value = true;

        Get.snackbar("Verified", response['message'] ?? "OTP Verified",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Failed", response['message'] ?? "Invalid OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
