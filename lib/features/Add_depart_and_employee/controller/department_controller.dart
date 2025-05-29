// lib/modules/department/controller/department_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/encryption/encryption_helper.dart';
import '../models/work_pattern_model.dart';
import '../services/department_service.dart';

class DepartmentController extends GetxController {
  final departmentNameController = TextEditingController();
  final supervisorController = TextEditingController();

  var workPattern = ''.obs;
  var isLoading = false.obs;

  List<String> workPatterns = ['Mon - Sat', 'Mon - Fri', 'Tue - Sat'];

  Future<void> submitDepartment(String phone,WorkPattern selectedWorkPattern) async {
    if (departmentNameController.text.isEmpty ||
        selectedWorkPattern == null ||
        supervisorController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please fill all fields');
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
      );

      if (result) {
        Get.snackbar('Success', 'Department added successfully');
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back();
        });
      } else {
        Get.snackbar('Error', 'Failed to add department');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
}
