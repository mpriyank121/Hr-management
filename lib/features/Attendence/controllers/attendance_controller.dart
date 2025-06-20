import 'package:get/get.dart';
import '../Models/employee_attendance_model.dart';
import '../services/employee_attendence_service.dart';

class AttendanceController extends GetxController {
  var attendanceList = <AttendanceModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> getAttendance({
    required String type,
    required String mob,
    required String startDate,
    required String endDate,
    required String id,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await AttendanceService.fetchAttendance(
        type: type,
        mob: mob,
        startDate: startDate,
        endDate: endDate,
        id: id,
      );
      attendanceList.assignAll(data);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
