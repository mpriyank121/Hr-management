import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/auth_service.dart';
import '../data/organization_service.dart';

// Replace your current controller with this:

class CompanyDetailsController extends GetxController {
  // Form field controllers
  final orgNameController = TextEditingController();
  final industryTypeController = TextEditingController();
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

  // Observables
  var phone = ''.obs;
  var otp = ''.obs;
  var otpController = TextEditingController();
  var isOtpSent = false.obs;
  var isFetchingLocation = false.obs;
  final RxBool isPhoneVerified = false.obs;
  var isEditing = false.obs;
  var panImageUrl = ''.obs;
  var orgLogoUrl = ''.obs;
  RxString state = ''.obs;
  RxString city = ''.obs;
  RxString stateName = ''.obs;
  RxString cityName = ''.obs;
  String? stateId;
  String? cityId;
  var userManuallyChangedPincode = false.obs;




  @override
  void onClose() {
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
    otpController.dispose();
    super.onClose();
  }

  Future<void> onPincodeChanged(String pin) async {
    // Only proceed if the user actually changed it manually
    if (!userManuallyChangedPincode.value) return;
    if (pin.length != 6) return;

    isFetchingLocation.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
      );

      request.fields.addAll({
        'type': '102a105a93a91a110a99a105a104a60a115a74a99a104a93a105a94a95a104',
        'pincode': EncryptionHelper.encryptString(pin),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        if (decoded['status'] == true && decoded['data'] != null) {
          stateId = decoded['data']['stateId'] ?? '';
          cityId = decoded['data']['cityID'] ?? '';

          stateName.value = decoded['data']['state'] ?? '';
          cityName.value = decoded['data']['city'] ?? '';
          stateController.text = stateName.value;
          cityController.text = cityName.value;
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
    if (!_validateFields()) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/apis.php'),
      );

      request.fields.addAll({
        'type': '109a96a98a100a110a111a109a92a111a100a106a105a103',
        'org_name': orgNameController.text.trim(),
        'industry_type': industryTypeController.text.trim(),
        'phone': EncryptionHelper.encryptString(phoneController.text.trim()),
        'email': EncryptionHelper.encryptString(emailController.text.trim()),
        'pincode': pincodeController.text.trim(),
        'state': stateId ?? '',
        'city': cityId ?? '',
        'address': addressController.text.trim(),
        'website': websiteController.text.trim(),
        'gst_no': gstNoController.text.trim(),
        'pan_number': panNumberController.text.trim(),
      });

      request.files.add(await http.MultipartFile.fromPath('pan_image', panImage!.path));
      request.files.add(await http.MultipartFile.fromPath('org_logo', orgLogo!.path));

      http.StreamedResponse response = await request.send();
      Get.back(); // Close loading dialog

      final responseBody = await response.stream.bytesToString();
      final decoded = jsonDecode(responseBody);

      if (decoded['status'] == true) {
        Get.snackbar("Success", "Company registered successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        // Optionally reset form here
      } else {
        Get.snackbar("Failed", decoded['message'] ?? "Something went wrong.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "An error occurred during registration. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  bool _validateFields() {
    if (orgNameController.text.trim().isEmpty ||
        industryTypeController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        panNumberController.text.trim().isEmpty ||
        panImage == null ||
        orgLogo == null) {
      Get.snackbar("Missing Information", "Please fill in all required fields marked with *.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return false;
    }

    if (!isPhoneVerified.value) {
      Get.snackbar("Phone Not Verified", "Please verify your phone number before registering.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> sendOtpToUser() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar("Error", "Please enter phone number");
      return;
    }

    try {
      final response = await AuthService.sendOtp(phone);
      if (response['status'] == true) {
        isOtpSent.value = true;
        isPhoneVerified.value = false;
        Get.snackbar("Success", response['message'] ?? "OTP sent");
      } else {
        Get.snackbar("Error", response['message'] ?? "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> verifyUserOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "Enter OTP");
      return;
    }

    try {
      final response = await AuthService.verifyOtp(phone, otp);

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          isPhoneVerified.value = true;
          Get.snackbar("Verified", response['message'] ?? "OTP Verified");
        } else {
          Get.snackbar("Failed", response['message'] ?? "Invalid OTP");
        }
      } else if (response is List && response.isEmpty) {
        Get.snackbar("Error", "Server returned an empty list");
      } else {
        Get.snackbar("Error", "Unexpected response format");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }
  }

  void fetchAndSetCompanyDetails(String phoneNumber) async {
    try {
      final response = await OrganizationService.fetchOrganizationByPhone();
      if (response != null) {
        orgNameController.text = response.orgName;
        industryTypeController.text = response.industryType;
        addressController.text = response.address;
        pincodeController.text = response.pincode;
        emailController.text = response.email;
        phoneController.text = response.phone;
        websiteController.text = response.website;
        gstNoController.text = response.gstNo;
        panNumberController.text = response.panNumber;

        panImageUrl.value = "https://img.bookchor.com/${response.panImageUrl}";
        orgLogoUrl.value = "https://img.bookchor.com/${response.orgLogo}";

        stateId = response.stateId;
        cityId = response.cityId;

        // Prevent triggering API call

        stateController.text = response.state;
        cityController.text = response.city;

        // Optionally reset back after a small delay


        isEditing.value = true;
      }
    } catch (e) {
      print("❌ Error fetching company details: $e");
    }
  }


}

