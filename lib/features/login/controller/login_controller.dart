import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

import '../../../core/shared_pref_helper_class.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  var isLoading = false.obs;

  final isOtpSent = false.obs;
  final isPhoneVerified = false.obs;

  /// Send OTP
  Future<void> sendOtpToUser() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "Please enter phone number",
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await LoginAuthService.sendOtp(phone);
      if (response['status'] == true) {
        isOtpSent.value = true;
        isPhoneVerified.value = false;

        CustomToast.showMessage(
          context: Get.context!,
          title: "Success",
          message: response['message'] ?? "OTP sent",
          isError: false,
        );
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: "Error",
          message: response['message'] ?? "Failed to send OTP",
          isError: true,
        );
      }
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<void> verifyUserOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;
      final response = await LoginAuthService.verifyOtp(phone, otp);
      if (response['success'] == true) {
        isPhoneVerified.value = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await SharedPrefHelper.savePhone(phone);

        Get.offAllNamed('/home');
      } else {
        // Handle failure silently or as needed
      }
    } catch (e) {
      // Handle error silently or as needed
    } finally {
      isLoading.value = false;
    }
  }
}