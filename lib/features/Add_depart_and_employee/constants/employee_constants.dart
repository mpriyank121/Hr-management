class EmployeeConstants {
  static const Map<String, String> roleMap = {"Admin": "1", "Employee": "2"};
  static const List<String> genderOptions = ["Male", "Female", "Other"];
  
  // Validation messages
  static const String nameRequired = "Name is required";
  static const String phoneRequired = "Phone is required";
  static const String emailRequired = "Email is required";
  static const String invalidEmail = "Enter a valid email";
  static const String startDateRequired = "Start date required";
  static const String fillAllFields = "Please fill all required fields.";
  static const String invalidRole = "Invalid role selected.";
  
  // Form field hints
  static const String employeeNameHint = "Employee Name";
  static const String employeeCodeHint = "Employee Code";
  static const String phoneHint = "Enter Number";
  static const String emailHint = "example@gmail.com";
  static const String joiningDateHint = "Joining Date";
  static const String selectRoleHint = "Select Role";
  static const String selectPositionHint = "Select Position";
  static const String selectJobTypeHint = "Select Job Type";
  static const String selectDepartmentHint = "Select Department";
  
  // Section titles
  static const String employeeProfileTitle = "Employee Profile";
  static const String fullNameTitle = "Full Name";
  static const String positionTitle = "Position";
  static const String employmentTypeTitle = "Employment Type";
  static const String userRoleTitle = "User Role";
  static const String employeeCodeTitle = "Employee Code";
  static const String departmentTitle = "Department";
  static const String genderTitle = "Gender";
  static const String phoneNumberTitle = "Phone Number";
  static const String emailTitle = "Email";
  static const String panCardTitle = "Upload your PAN card";
  static const String joiningDateTitle = "Joining Date Of Employee";
} 