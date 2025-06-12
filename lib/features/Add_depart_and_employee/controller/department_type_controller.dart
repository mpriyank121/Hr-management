import 'package:get/get.dart';
import '../models/department_type_model.dart';
import '../services/department_service.dart';
import '../services/department_type.dart';

class DepartmentTypeController extends GetxController {
  var departmentList = <DepartmentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // ✅ Correct nullable observable declaration
  final Rxn<DepartmentModel> selectedDepartment = Rxn<DepartmentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }
  Future<bool> fetchDepartments() async {
    try {
      isLoading.value = true;

      final result = await DepartmentTypeService.fetchDepartmenttypes(department: 'department');
      departmentList.assignAll(result); // ✅ Correct reactive update

      return true; // ✅ Must return something
    } catch (e) {
      errorMessage.value = e.toString();
      return false; // ✅ Return false on failure
    } finally {
      isLoading.value = false;
    }
  }


  void selectDepartment(DepartmentModel? department) {
    selectedDepartment.value = department;
  }

  DepartmentModel? getDepartmentById(String id) {
    return departmentList.firstWhereOrNull((dept) => dept.id == id);
  }
}
