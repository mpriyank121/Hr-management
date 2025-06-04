import 'dart:convert';

import 'package:get/get.dart';
import '../Models/holiday_list_model.dart';
import '../services/holiday_add_service.dart';
import '../services/holiday_list_service.dart';


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
          Get.snackbar("Success", json['message'] ?? "Holiday added");
          loadHolidays(); // refresh holiday list
        } else {
          Get.snackbar("Failed", json['message'] ?? "Something went wrong");
        }
      } else {
        Get.snackbar("Error", response.reasonPhrase ?? "Server error");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmitting.value = false;
    }


  }

  void changeYear(int year) {
    selectedYear.value = year;
    loadHolidays();
  }
}