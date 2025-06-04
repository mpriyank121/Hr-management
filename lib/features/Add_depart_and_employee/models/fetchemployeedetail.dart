class EmployeeDetailModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String gender;
  final String departmentId;
  final String departmentName;
  final String positionId;
  final String positionName;
  final String employeeCode;
  final String empType;
  final String? profileUrl;
  final String? panUrl;
  final String? doj;
  final String? userRoleId;

  EmployeeDetailModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.departmentId,
    required this.departmentName,
    required this.positionId,
    required this.positionName,
    required this.employeeCode,
    required this.empType,
    this.profileUrl,
    this.panUrl,
    this.doj,
    this.userRoleId,
  });

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailModel(
      id: '', // If there's no `id`, leave it empty or handle differently
      name: json['emp_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      departmentId: json['department']?.toString() ?? '',
      departmentName: json['department'] ?? '', // optional, not in response
      positionId: json['position']?.toString() ?? '',
      positionName: json['position_name'] ?? '', // optional, not in response
      employeeCode: json['emp_code'] ?? '',
      empType: json['emp_type'] ?? '',
      profileUrl: json['emp_image'] != null
          ? 'https://img.bookchor.com/${json['emp_image']}'
          : null,
      panUrl: json['pan'] != null
          ? 'https://img.bookchor.com/${json['pan']}'
          : null,
      doj: json['doj'],
      userRoleId: json['user_role']?.toString(),
    );
  }

}
