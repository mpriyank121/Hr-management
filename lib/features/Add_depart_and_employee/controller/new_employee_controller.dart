import 'package:get/get.dart';
import '../models/new_employee_model.dart';
import '../services/new_employee_service.dart';

class NewEmployeeController extends GetxController {
  var isSubmitting = false.obs;
  var submissionMessage = ''.obs;

  Future<void> submitNewEmployee(NewEmployeeModel model) async {
    try {
      isSubmitting.value = true;
      final result = await NewEmployeeService.submitEmployee(model);

      if (result) {
        submissionMessage.value = 'Employee added successfully!';
        Get.back();
        // Optionally: Navigate or reset form
      } else {
        submissionMessage.value = 'Failed to add employee.';
      }
    } catch (e) {
      submissionMessage.value = 'Error: $e';
    } finally {
      isSubmitting.value = false;
    }
  }
}
