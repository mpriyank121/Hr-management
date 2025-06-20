import 'dart:io';

class NewEmployeeModel {
  final String empName;
  final String phone;
  final String email;
  final String departmentId;
  final String gender;
  final String positionId;
  final String EmployeeCode;
  final String empTypeId;
  final String? salary;
  final String? panFilePath;
  final String? date;
  final String? profilePath;
  final String? UserRoleId;
  final String? empId;
  final String? dob;
  String? originalProfilePath;    // Server-fetched path
  String? originalPanFilePath;


  NewEmployeeModel({
    required this.empName,
    required this.phone,
    required this.email,
    required this.departmentId,
    required this.gender,
    required this.positionId,
    required this.EmployeeCode,
    required this.empTypeId,
    this.salary,
    this.panFilePath,
    required this.date,
    this.profilePath,
    this.UserRoleId,
    this.empId,
    this.dob,
    this.originalPanFilePath,
    this.originalProfilePath
  });
}
