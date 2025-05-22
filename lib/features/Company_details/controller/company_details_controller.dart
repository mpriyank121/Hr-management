import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/auth_service.dart';

class CompanyDetailsController extends GetxController {
  // Form field controllers
  final orgNameController = TextEditingController();
  final industryTypeController = TextEditingController(); // if needed
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final gstNoController = TextEditingController();
  final panNumberController = TextEditingController();

  // File pickers
  File? orgLogo;
  File? panImage;
  var phone = ''.obs;
  var otp = ''.obs;
  var otpController = TextEditingController();
  var isOtpSent = false.obs;

  // Loading indicator
  var isFetchingLocation = false.obs;
  final RxBool isPhoneVerified = false.obs;


  @override
  void onClose() {
    // Dispose all controllers
    orgNameController.dispose();
    industryTypeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    pincodeController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    websiteController.dispose();
    gstNoController.dispose();
    panNumberController.dispose();
    super.onClose();
  }

  void onPincodeChanged(String pin) async {
    if (pin.length != 6) return;

    isFetchingLocation.value = true;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
    );

    request.fields.addAll({
      'type': '102a105a93a91a110a99a105a104a60a115a74a99a104a93a105a94a95a104',
      'pincode': EncryptionHelper.encryptString(pin),
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);

        if (decoded['status'] == true &&
            decoded['data'] != null &&
            decoded['data']['state'] != null &&
            decoded['data']['city'] != null) {
          stateController.text = decoded['data']['state'];
          cityController.text = decoded['data']['city'];
        } else {
          Get.snackbar("Error", "Invalid PIN Code or no data found");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch location: ${response.reasonPhrase}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception occurred: $e");
    } finally {
      isFetchingLocation.value = false;
    }
  }


  Future<void> registerCompany() async {
    if (!isPhoneVerified.value) {
      Get.snackbar("Error", "Please verify your phone number before registering.");
      return;
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
    );

    request.fields.addAll({
      'type': '109a96a98a100a110a111a109a92a111a100a106a105a103',
      'org_name': orgNameController.text,
      'industry_type': industryTypeController.text,
      'phone': EncryptionHelper.encryptString(phoneController.text),
      'email': EncryptionHelper.encryptString(emailController.text),
      'pincode': pincodeController.text,
      'state': stateController.text,
      'city': cityController.text,
      'address': addressController.text,
      'website': websiteController.text,
      'gst_no': gstNoController.text,
      'pan_number': panNumberController.text,
    });

    if (panImage != null) {
      request.files.add(await http.MultipartFile.fromPath('pan_image', panImage!.path));
    }

    if (orgLogo != null) {
      request.files.add(await http.MultipartFile.fromPath('org_logo', orgLogo!.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('✅ Registration successful: $responseBody');
    } else {
      print('❌ Registration failed: ${response.reasonPhrase}');
    }
  }

  /// Send OTP
  Future<void> sendOtpToUser() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar("Error", "Please enter phone number");
      return;
    }

    try {
      final encodedPhone = (phone); // Use your encoding method
      final response = await AuthService.sendOtp(encodedPhone);
      if (response['status'] == true) {
        isPhoneVerified.value = true;
        isOtpSent.value = true;
        Get.snackbar("Success", response['message'] ?? "OTP sent");
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Verify OTP
  Future<void> verifyUserOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "Enter OTP");
      return;
    }

    try {
      // Send raw values, encryption is done inside AuthService
      final response = await AuthService.verifyOtp(phone, otp);

      if (response['success'] == true) {
        isPhoneVerified.value = true; // Mark as verified ✅

        Get.snackbar("Verified", response['message'] ?? "OTP Verified");
      } else {
        Get.snackbar("Failed", response['message'] ?? "Invalid OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
