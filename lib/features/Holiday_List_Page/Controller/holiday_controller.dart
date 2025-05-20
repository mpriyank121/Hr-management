import 'package:get/get.dart';
import '../Models/holiday_list_model.dart';

class HolidayController extends GetxController {
  var holidays = <Holiday>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHolidays();
  }

  void loadHolidays() {
    holidays.value = [
      Holiday(holiday: 'New Year\'s Day', holiday_date: '2025-01-01'),
      Holiday(holiday: 'Republic Day', holiday_date: '2025-01-26'),
      Holiday(holiday: 'Independence Day', holiday_date: '2025-08-15'),
    ];
  }
}
