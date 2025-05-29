import 'dart:io';

class NewEmployeeModel {
  final String empName;
  final String phone;
  final String email;
  final String departmentId;
  final String gender;
  final String positionId;
  final String website;
  final String empTypeId;
  final String? panFilePath;
  final String? date;
  final String? profilePath;// Nullable for optional upload

  NewEmployeeModel({
    required this.empName,
    required this.phone,
    required this.email,
    required this.departmentId,
    required this.gender,
    required this.positionId,
    required this.website,
    required this.empTypeId,
    this.panFilePath,
    required this.date,
    this.profilePath,
  });
}
