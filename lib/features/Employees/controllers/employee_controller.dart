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
  final RxList<Employee> assignedEmployees = <Employee>[].obs;
  final RxList<Employee> unassignedEmployees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final employeeData = await EmployeeService.fetchEmployees();
      assignedEmployees.assignAll(employeeData['assigned'] ?? []);
      unassignedEmployees.assignAll(employeeData['unassigned'] ?? []);
      employeeList.assignAll(employeeData['assigned'] ?? []); // Ensure UI using employeeList works
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  /// Get employee by ID
  Employee? getEmployeeById(String id) {
    return employeeList.firstWhereOrNull((emp) => emp.id == id);
  }
  /// Add new employee
  void addEmployee(Employee newEmployee) {
    employeeList.add(newEmployee);
    employeeList.refresh(); // Trigger UI update
  }
}
