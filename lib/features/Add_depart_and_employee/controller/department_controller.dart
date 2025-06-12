import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/work_pattern_model.dart';
import '../services/department_service.dart';
import 'department_type_controller.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';

class DepartmentController extends GetxController {
  final departmentNameController = TextEditingController();
  final supervisorController = TextEditingController();
  final DepartmentTypeController departmentController = Get.put(
      DepartmentTypeController());
  var workPattern = ''.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;

  List<String> workPatterns = ['Mon - Sat', 'Mon - Fri', 'Tue - Sat'];

  Future<void> submitDepartment(String phone, WorkPattern selectedWorkPattern) async {
    if (departmentNameController.text.isEmpty ||
        selectedWorkPattern == null ||
        supervisorController.text.isEmpty) {
      CustomToast.showMessage(
        context: Get.context!,
        title: 'Validation Error',
        message: 'Please fill all fields',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final encryptedPhone = (phone);

      final result = await DepartmentService.submitDepartment(
        storedPhone: encryptedPhone,
        department: departmentNameController.text.trim(),
        workType: _mapWorkPatternToCode(workPattern.value),
        supervisor: supervisorController.text.trim(),
        isEditing: isEditing.value,
      );

      if (result) {
        CustomToast.showMessage(
          context: Get.context!,
          title: 'Success',
          message: isEditing.value ? 'Department updated successfully' : 'Department added successfully',
          isError: false,
        );
        await departmentController.fetchDepartments();
        Get.back();
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: 'Error',
          message: isEditing.value ? 'Failed to update department' : 'Failed to add department',
          isError: true,
        );
      }
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _mapWorkPatternToCode(String pattern) {
    switch (pattern) {
      case 'Mon - Fri':
        return '2';
      case 'Tue - Sat':
        return '3';
      case 'Mon - Sat':
      default:
        return '1';
    }
  }

  void setEditingMode(bool editing) {
    isEditing.value = editing;
  }

  void clearForm() {
    departmentNameController.clear();
    supervisorController.clear();
    workPattern.value = '';
    isEditing.value = false;
  }

  @override
  void onClose() {
    departmentNameController.dispose();
    supervisorController.dispose();
    super.onClose();
  }
  Future<void> editDepartmentDetails({
    required String department,
    required String workType,
    required String supervisor,
    required String type,
    required String departmentId,
  }) async {
    try {
      isLoading.value = true;

      final storedPhone = await SharedPrefHelper.getPhone();

      final success = await editDepartment(
        department: department,
        workType: workType,
        departmentId: departmentId,
        supervisor: supervisor,
        storedPhone: storedPhone ?? '',
        editDepartment: type,
        isEditing: true,
      );

      if (success) {
        CustomToast.showMessage(
          context: Get.context!,
          title: 'Success',
          message: 'Department updated successfully',
          isError: false,
        );

        final fetched = await departmentController.fetchDepartments();
        if (fetched) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.back(); // 👈 Ensures smoother UI flow
          });
        }
      } else {
        CustomToast.showMessage(
          context: Get.context!,
          title: 'Error',
          message: 'Failed to update department',
          isError: true,
        );
      }
    } catch (e) {
      CustomToast.showMessage(
        context: Get.context!,
        title: 'Error',
        message: 'Something went wrong: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

}
