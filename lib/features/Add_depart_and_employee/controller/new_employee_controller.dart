import 'package:get/get.dart';
import '../../Employees/service/employee_service.dart';
import '../models/new_employee_model.dart';
import '../services/new_employee_service.dart';

class NewEmployeeController extends GetxController {
  var isSubmitting = false.obs;
  var submissionMessage = ''.obs;
  var employee = Rxn<NewEmployeeModel>(); // nullable reactive employee model
  var isLoading = false.obs;
  var errorMessage = ''.obs;
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
  Future<void> fetchEmployee(String empId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedEmployee = await NewEmployeeService.fetchEmployeeById(empId);

      if (fetchedEmployee != null) {
        employee.value = fetchedEmployee as NewEmployeeModel?;
      } else {
        errorMessage.value = 'Employee not found or error fetching data';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear employee data (for adding new employee)
  void clearEmployee() {
    employee.value = null;
    errorMessage.value = '';
  }
}
