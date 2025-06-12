import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import '../../../core/shared_pref_helper_class.dart';
import '../models/salary_structure_model.dart';
import '../services/salary_structure_service.dart';
import 'package:hr_management/core/widgets/custom_toast.dart';
import 'package:http/http.dart' as http;

class SalaryStructureController extends GetxController {
  final salaryType = "CTC".obs;
  final basicSalary = 0.0.obs;
  final hra = 0.0.obs;
  final pf = 0.0.obs;
  final esi = 0.0.obs;
  final professionalTax = 0.0.obs;
  final totalDeductions = 0.0.obs;
  final netSalary = 0.0.obs;
  final ctc = 0.0.obs;

  final employeeName = ''.obs;
  final departmentName = ''.obs;
  final isLoading = false.obs;

  void updateSalaryType(String type) {
    salaryType.value = type;
    _calculateSalary();
  }

  void updateBasicSalary(double amount) {
    basicSalary.value = amount;
    _calculateSalary();
  }

  void updateCTC(double amount) {
    ctc.value = amount;
    _calculateSalary();
  }

  void _calculateSalary() {
    if (salaryType.value == "CTC") {
      basicSalary.value = ctc.value * 0.4; // 40% of CTC
      hra.value = basicSalary.value * 0.4; // 40% of Basic
      pf.value = basicSalary.value * 0.12; // 12% of Basic
      esi.value = ctc.value * 0.0075; // 0.75% of CTC
      professionalTax.value = 200; // Fixed amount
    } else {
      ctc.value = (basicSalary.value + hra.value) * 1.2; // Approximate CTC
    }
    
    totalDeductions.value = pf.value + esi.value + professionalTax.value;
    netSalary.value = basicSalary.value + hra.value - totalDeductions.value;
  }

  Future<bool> fetchEmployeeDetails(String empCode) async {
    final storedPhone = await SharedPrefHelper.getPhone();
    try {
      isLoading.value = true;
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/home.php')
      );
      
      final encryptedPhone = EncryptionHelper.encryptString(storedPhone!);
      final encryptedEmpCode = EncryptionHelper.encryptString(empCode.toUpperCase());
      
      print('Original emp_code: ${empCode.toUpperCase()}');
      print('Encrypted emp_code: $encryptedEmpCode');
      print('Encrypted phone: $encryptedPhone');
      
      request.fields.addAll({
        'type': '101a99a114a67a107a110a100',
        'mob': encryptedPhone,
        'emp_code': encryptedEmpCode,
      });

      print('Request fields: ${request.fields}');
      
      http.StreamedResponse response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Raw API Response: $responseData');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        print('Parsed JSON: $jsonData');
        print('Status: ${jsonData['status']}');
        print('Data: ${jsonData['data']}');

        if (jsonData['message'] == 'found' && jsonData['data'] != null && jsonData['data'] is List && jsonData['data'].isNotEmpty) {
          final data = jsonData['data'][0];
          print('Employee data: $data');

          employeeName.value = data['emp_name'] ?? '';
          departmentName.value = data['department_name'] ?? '';

          if (employeeName.value.isEmpty && departmentName.value.isEmpty) {
            print('Warning: Both name and department are empty');
            return false;
          }

          return true;
        }
        else {
          print('API returned success but no data or invalid data');
          print('Status: ${jsonData['status']}');
          print('Data: ${jsonData['data']}');
          employeeName.value = '';
          departmentName.value = '';
          return false;
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        employeeName.value = '';
        departmentName.value = '';
        return false;
      }
    } catch (e) {
      print('Error fetching employee details: $e');
      print('Stack trace: ${StackTrace.current}');
      employeeName.value = '';
      departmentName.value = '';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitSalaryStructure(SalaryStructureModel model) async {
    try {
      isLoading.value = true;
      
      final result = await SalaryStructureService.submitSalaryStructure(model);
      
      if (result) {
        CustomToast.showMessage(
          context: Get.context!,
          title: 'Success',
          message: 'Salary structure saved successfully',
          isError: false,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
} 