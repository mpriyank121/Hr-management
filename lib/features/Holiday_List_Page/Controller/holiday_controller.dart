import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/holiday_list_model.dart';
import '../services/holiday_add_service.dart';
import '../services/holiday_list_service.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';


class HolidayController extends GetxController {
  var holidayList = <Holiday>[].obs;
  var isLoading = false.obs;
  var selectedYear = DateTime
      .now()
      .year
      .obs;
  var isSubmitting = false.obs;

  Future<void> loadHolidays() async {
    try {
      isLoading.value = true;
      print('📦 Fetching holidays for year ${selectedYear.value}');
      final holidays = await HolidayService.fetchHolidays(
          year: selectedYear.value.toString());
      holidayList.value = holidays;

    } catch (e) {
      print('❌ Error loading holidays: $e');
      holidayList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHoliday({
    required String holiday,
    required String holidayDate,
    required String year,
  }) async {
    isSubmitting.value = true;

    try {
      final response = await HolidayAddService.addHoliday(
        holiday: holiday,
        holidayDate: holidayDate,
        year: year,
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final json = jsonDecode(body);
        print("✅ Add Holiday Response: $json");

        if (json['status'] == true) {
          CustomToast.showMessage(
            context: Get.context!,
            title: "Success",
            message: json['message'] ?? "Holiday added",
            isError: false,
          );
          await loadHolidays(); // refresh holiday list
          Get.back();
        } else {
          CustomToast.showMessage(
            context: Get.context!,
            title: "Failed",
            message: json['message'] ?? "Something went wrong",
            isError: true,
          );
        }
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: "Error",
          message: response.reasonPhrase ?? "Server error",
          isError: true,
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "Something went wrong",
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  Future<void> editHoliday({
    required String holiday,
    required String holidayDate,
    required String year,
    required String id,
  }) async {
    isSubmitting.value = true;

    try {
      final response = await HolidayAddService.editHoliday(
        holiday: holiday,
        holidayDate: holidayDate,
        year: year,
        id: id,
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final json = jsonDecode(body);
        print("✅ Edit Holiday Response: $json");

        if (json['status'] == true) {
          CustomToast.showMessage(
            context: Get.context!,
            title: "Success",
            message: json['message'] ?? "Holiday Edited",
            isError: false,
          );
          await loadHolidays(); // refresh holiday list
          Get.back();
        } else {
          CustomToast.showMessage(
            context: Get.context!,
            title: "Failed",
            message: json['message'] ?? "Something went wrong",
            isError: true,
          );
        }
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: "Error",
          message: response.reasonPhrase ?? "Server error",
          isError: true,
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "Something went wrong",
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  Future<void> deleteHoliday( {required String id}) async {
    try {
      // Optional: show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await HolidayAddService.deleteHoliday(id: id);

      // Close loader
      Get.back();

      if (response.statusCode == 200) {
        // You may also parse and validate the actual response if needed

        // Refresh the holiday list
        await loadHolidays();

        CustomToast.showMessage(
          context: Get.context!,
          title: "Success",
          message: "Holiday deleted successfully",
          isError: false,
        );
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: "Error",
          message: "Failed to delete holiday",
          isError: true,
        );
      }
    } catch (e) {
      Get.back(); // Close loader if an error occurs
      CustomToast.showMessage(
        context: Get.context!,
        title: "Error",
        message: "An error occurred: $e",
        isError: true,
      );
    }
  }



  void changeYear(int year) {
    selectedYear.value = year;
    loadHolidays();
  }
}