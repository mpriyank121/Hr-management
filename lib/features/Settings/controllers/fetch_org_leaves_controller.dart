import 'package:get/get.dart';
import '../models/fetch_org_leave.dart';
import '../services/leave_fetch_service.dart';

class LeaveTypeController extends GetxController {
  var availableLeaveTypes = <OrgLeave>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var selectedLeave = Rxn<OrgLeave>();

  // Match HolidayController pattern
  var selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaveTypes(year: selectedYear.value); // initial load for current year
  }

  /// Fetch leave types for a specific year
  Future<void> loadLeaveTypes({required int year}) async {
    try {
      isLoading.value = true;
      print('📦 Fetching leave types for year $year');
      final result = await LeaveService.fetchorgleaves(year: year);
      if (result != null) {
        availableLeaveTypes.assignAll(result);
      } else {
        availableLeaveTypes.clear();
      }
    } catch (e) {
      print('❌ Error loading leave types: $e');
      availableLeaveTypes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Triggered from UI when year changes
  void changeYear(int year) {
    selectedYear.value = year;
    loadLeaveTypes(year: year);
  }

  void setSelectedLeave(OrgLeave? leave) {
    selectedLeave.value = leave;
  }
}
