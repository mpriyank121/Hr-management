import 'package:get/get.dart';
import '../models/fetchemployeedetail.dart';
import '../services/new_employee_service.dart';

class FetchEmployeeController extends GetxController {
  var isLoading = false.obs;
  var fetchEmployee = Rxn<EmployeeDetailModel>();
  var errorMessage = ''.obs;

  /// Fetch employee data by ID
  Future<void> fetchEmployeeById(String empId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetched = await NewEmployeeService.fetchEmployeeById(empId);
      if (fetched != null) {
        fetchEmployee.value = fetched ;
      } else {
        fetchEmployee.value = null;
        errorMessage.value = 'Employee not found or error fetching data.';
      }
    } catch (e) {
      fetchEmployee.value = null;
      errorMessage.value = 'Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear current employee data
  void clear() {
    fetchEmployee.value = null;
    errorMessage.value = '';
  }

}
