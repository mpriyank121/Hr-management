import 'package:hr_management/features/Add_depart_and_employee/constants/employee_constants.dart';

class ValidationUtils {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return EmployeeConstants.nameRequired;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return EmployeeConstants.phoneRequired;
    }
    if (value.length != 10) {
      return "Phone number must be 10 digits";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return EmployeeConstants.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return EmployeeConstants.invalidEmail;
    }
    return null;
  }

  static String? validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return EmployeeConstants.startDateRequired;
    }
    return null;
  }

  static bool validateForm({
    required bool isFormValid,
    required bool hasUserRole,
    required bool hasGender,
    required bool hasDepartment,
    required bool hasJobType,
    required bool hasPosition,
  }) {
    return isFormValid &&
        hasUserRole &&
        hasGender &&
        hasDepartment &&
        hasJobType &&
        hasPosition;
  }
} 