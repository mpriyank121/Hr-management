import 'package:get/get.dart';
import '../models/fetch_org_leave.dart';
import '../services/leave_fetch_service.dart';

class LeaveTypeController extends GetxController {
  var isLoading = false.obs;
  var availableLeaveTypes = <OrgLeave>[].obs;
  var selectedLeave = Rxn<OrgLeave>();
  var message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaveTypes();
  }

  Future<void> loadLeaveTypes() async {
    try {
      isLoading.value = true;

      final result = await LeaveService.fetchorgleaves();

      if (result != null) {
        availableLeaveTypes.assignAll(result);
        message.value = 'Leave types loaded successfully';
      } else {
        message.value = 'Failed to load leave types';
      }
    } catch (e) {
      message.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedLeave(OrgLeave? leave) {
    selectedLeave.value = leave;
  }
}
