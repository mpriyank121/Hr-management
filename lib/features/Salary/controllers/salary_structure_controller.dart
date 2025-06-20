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
  final basicSalary = 0.0.obs;
  final pf = 0.0.obs;
  final esi = 0.0.obs;
  final totalDeductions = 0.0.obs;
  final netSalary = 0.0.obs;
  final ctc = 0.0.obs;
  final salaryType = "CTC".obs;
  final employeeName = "".obs;
  final departmentName = "".obs;
  final employeeSalary = "".obs;
  final isLoading = false.obs;
  final pfPercent = 12.0.obs;
  final esiPercent = 0.75.obs;
  final pfManual = false.obs;
  final esiManual = false.obs;
  final pfManualValue = 0.0.obs;
  final esiManualValue = 0.0.obs;
  final otherallowance = 0.0.obs;
  final hra = 0.0.obs;
  final deductionKey = 0.obs;
  final professionalTax = 0.0.obs;

  // Store temporary values until Get Details is pressed
  int _tempDeductionKey = 0;
  List<String> _tempSelectedDeductions = [];

  // Add new observable for employee salary structure
  final employeeSalaryStructure = Rx<SalaryStructureModel?>(null);
  final isLoadingSalary = false.obs;
  final errorMessage = "".obs;

  Future<void> fetchDeductionsFromAPI(double amount) async {
    final storedPhone = await SharedPrefHelper.getPhone();
    print('Starting API call with amount: $amount and deduction key: $_tempDeductionKey'); // Debug log
    try {
      isLoading.value = true;
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php')
      );
      
      request.fields.addAll({
        'type': '106a88a99a88a105a112a86a89a105a92a88a98a91a102a110a101a107',
        "mob" : EncryptionHelper.encryptString(storedPhone!),
        'amount': amount.toString(),
        'id': _tempDeductionKey.toString(),
      });

      print('Sending API request: \\${request.fields}'); // Debug log
      
      http.StreamedResponse response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Received API response: \\${responseData}'); // Debug log
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        print('Parsed JSON data: \\${jsonData}'); // Debug log
        
        if (jsonData['message'] == 'found') {
          // Update all values at once after API call
          basicSalary.value = amount;
          deductionKey.value = _tempDeductionKey;
          pf.value = double.tryParse(jsonData['pf_employee']?.toString() ?? '0') ?? 0;
          esi.value = double.tryParse(jsonData['esic_employee']?.toString() ?? '0') ?? 0;
          netSalary.value = double.tryParse(jsonData['net_amount']?.toString() ?? '0') ?? 0;
          totalDeductions.value = double.tryParse(jsonData['total_deduction']?.toString() ?? '0') ?? 0;
          basicSalary.value = double.tryParse(jsonData['basic_pay']?.toString() ?? '0') ?? 0;
          hra.value = double.tryParse(jsonData['hra_pay']?.toString() ?? '0') ?? 0;
          otherallowance.value = double.tryParse(jsonData['other_pay']?.toString() ?? '0') ?? 0;
          ctc.value = double.tryParse(jsonData['ctc']?.toString() ?? '0') ?? 0;
          professionalTax.value = double.tryParse(jsonData['tax']?.toString() ?? '0') ?? 0;
        }
      } else {
        print('API call failed with status: \\${response.statusCode}'); // Debug log
      }
    } catch (e) {
      print('Error in fetchDeductionsFromAPI: $e'); // Debug log
    } finally {
      isLoading.value = false;
    }
  }

  void updateBasicSalary(double amount) {
    basicSalary.value = amount;
  }

  // Store selected deductions temporarily
  void updateDeductions(List<String> selectedDeductions) {
    print('Storing temporary deductions: $selectedDeductions'); // Debug log
    _tempSelectedDeductions = List.from(selectedDeductions);
  }

  void updateSalaryType(String type) {
    salaryType.value = type;
    if (type != "CTC") {
      // Clear all values for Take Home
      pf.value = 0;
      esi.value = 0;
      hra.value = 0;
      otherallowance.value = 0;
      totalDeductions.value = 0;
      ctc.value = 0;
      netSalary.value = 0;
      _tempDeductionKey = 0;
      _tempSelectedDeductions.clear();
    }
  }

  void setPfValue(double value) {
    pf.value = value;
    updateCalculations();
  }

  void setEsiValue(double value) {
    esi.value = value;
    updateCalculations();
  }

  void updateCalculations() {
    totalDeductions.value = pf.value + esi.value;
    netSalary.value = basicSalary.value - totalDeductions.value;
    
    if (salaryType.value == "Take Home") {
      ctc.value = basicSalary.value * 1.2; // Approximate CTC
    }
    print('Calculations updated - Total Deductions: ${totalDeductions.value}, Net Salary: ${netSalary.value}'); // Debug log
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
          employeeSalary.value = data['salary']?.toString() ?? '';

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
        print(result);
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Store deduction key temporarily
  void updateDeductionKey(int key) {
    print('Storing temporary deduction key: $key'); // Debug log
    _tempDeductionKey = key;
  }
  int getSalaryTypeCode() {
    return salaryType.value == 'CTC' ? 1 : 2;
  }

  Future<void> fetchEmployeeSalary(String employeeCode) async {
    try {
      isLoadingSalary.value = true;
      errorMessage.value = "";

      final salaryData = await SalaryStructureService.fetchEmployeeSalaryDetails(employeeCode);
      
      if (salaryData != null) {
        employeeSalaryStructure.value = SalaryStructureModel(
          employeeCode: employeeCode,
          employeeName: salaryData['emp_name'] ?? '',
          departmentId: salaryData['department_id'] ?? '',
          salaryType: salaryData['salary_type'] ?? 'CTC',
          basicSalary: double.tryParse(salaryData['basic_pay']?.toString() ?? '0') ?? 0,
          pf: double.tryParse(salaryData['pf_employee']?.toString() ?? '0') ?? 0,
          esi: double.tryParse(salaryData['esic_employee']?.toString() ?? '0') ?? 0,
          hra: double.tryParse(salaryData['hra']?.toString() ?? '0') ?? 0,
          totalDeductions: double.tryParse(salaryData['total_deductions']?.toString() ?? '0') ?? 0,
          netSalary: double.tryParse(salaryData['net_amount']?.toString() ?? '0') ?? 0,
          ctc: double.tryParse(salaryData['ctc']?.toString() ?? '0') ?? 0,
          otherAllowances: double.tryParse(salaryData['other_pay']?.toString() ?? '0'),
          proffesionalTax: double.tryParse(salaryData['tax']?.toString() ?? '0')
        );
      } else {
        errorMessage.value = "Failed to fetch salary details";
      }
    } catch (e) {
      print('Error in fetchEmployeeSalary: $e');
      errorMessage.value = "Error: ${e.toString()}";
    } finally {
      isLoadingSalary.value = false;
    }
  }

  Future<void> fetchDeductionsFromAPIWithMonthAndDays(double amount, String month, int workingDays) async {
    print('Calling API with amount: $amount, month: $month, workingDays: $workingDays');
    try {
      isLoading.value = true;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/hrms/v1/employee.php'),
      );
      request.fields.addAll({
        'type': '106a88a99a88a105a112a86a89a105a92a88a98a91a102a110a101a107',
        'amount': amount.toString(),
        'id': _tempDeductionKey.toString(),

        'working_days': workingDays.toString(),
      });
      print('Sending API request: \\${request.fields}');
      http.StreamedResponse response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Received API response: \\${responseData}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData);
        print('Parsed JSON data: \\${jsonData}');
        if (jsonData['message'] == 'found') {
          basicSalary.value = amount;
          deductionKey.value = _tempDeductionKey;
          pf.value = double.tryParse(jsonData['pf_employee']?.toString() ?? '0') ?? 0;
          esi.value = double.tryParse(jsonData['esic_employee']?.toString() ?? '0') ?? 0;
          netSalary.value = double.tryParse(jsonData['net_amount']?.toString() ?? '0') ?? 0;
          totalDeductions.value = double.tryParse(jsonData['total_deduction']?.toString() ?? '0') ?? 0;
          basicSalary.value = double.tryParse(jsonData['basic_pay']?.toString() ?? '0') ?? 0;
          hra.value = double.tryParse(jsonData['hra_pay']?.toString() ?? '0') ?? 0;
          otherallowance.value = double.tryParse(jsonData['other_pay']?.toString() ?? '0') ?? 0;
          ctc.value = double.tryParse(jsonData['ctc']?.toString() ?? '0') ?? 0;
        }
      } else {
        print('API call failed with status: \\${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchDeductionsFromAPIWithMonthAndDays: \\${e}');
    } finally {
      isLoading.value = false;
    }
  }
} 