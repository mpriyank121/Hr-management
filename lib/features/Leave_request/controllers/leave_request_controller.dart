import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/LeaveRequestModel.dart';
import '../services/leave_request_service.dart';

class LeaveRequestController extends GetxController {
  var leaveList = <LeaveRequestModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeavesRequests();
  }

  Future<void> fetchLeavesRequests() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await LeaveRequestService.fetchLeaveRequests();
      // Sort the leave requests by applyDate in descending order (newest first)
      data.sort((a, b) {
        final dateA = DateFormat('yyyy-MM-dd').parse(a.applyDate);
        final dateB = DateFormat('yyyy-MM-dd').parse(b.applyDate);
        return dateB.compareTo(dateA); // Descending order
      });
      leaveList.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLeaveStatus({
    required String leaveId,
    required int action, // 2 = Approve, 3 = Decline
    required String reason,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/leave.php'),
      );

      request.fields.addAll({
        'type': '104a97a93a114a97a61a95a112a101a107a106a102',
        'id': EncryptionHelper.encryptString(leaveId),
        'action': action.toString(),
        'reason': reason,
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      await fetchLeavesRequests(); // Refresh the list after update

      print("✅ Leave updated: $responseBody");
    } catch (e) {
      print("❌ Error updating leave: $e");
    }
  }
}
