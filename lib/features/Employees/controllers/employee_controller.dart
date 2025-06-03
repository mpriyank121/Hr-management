import 'package:get/get.dart';
import '../../Employees/models/employee_model.dart';
import '../service/employee_service.dart';

class EmployeeController extends GetxController {
  var employeeList = <Employee>[].obs;

  // Group employees by department as a computed property
  Map<String, List<Employee>> get departmentWiseEmployees {
    final Map<String, List<Employee>> map = {};
    for (var emp in employeeList) {
      if (map.containsKey(emp.department)) {
        map[emp.department]!.add(emp);
      } else {
        map[emp.department] = [emp];
      }
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() async {
    try {
      final employees = await EmployeeService.fetchEmployees();
      employeeList.assignAll(employees);
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  /// Get employee by ID
  Employee? getEmployeeById(String id) {
    return employeeList.firstWhereOrNull((emp) => emp.id == id);
  }

  /// Update employee
  void updateEmployee(Employee updatedEmployee) {
    final index = employeeList.indexWhere((emp) => emp.id == updatedEmployee.id);
    if (index != -1) {
      employeeList[index] = updatedEmployee;
      employeeList.refresh(); // Trigger UI update
    }
  }

  /// Add new employee
  void addEmployee(Employee newEmployee) {
    employeeList.add(newEmployee);
    employeeList.refresh(); // Trigger UI update
  }
}
