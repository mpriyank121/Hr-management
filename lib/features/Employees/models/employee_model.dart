enum EmploymentStatus { permanent, contract, intern, partTime }

class Employee {
  final String id;
  final String name;
  final String department;
  final String avatarUrl;
  final EmploymentStatus employmentStatus;
  final String position;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.avatarUrl,
    required this.employmentStatus,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      name: json['emp_name'] ?? '',
      department: json['department'] ?? '',
      avatarUrl: 'https://img.bookchor.com/${json['emp_image']}' ?? '',
      employmentStatus: _employmentStatusFromString(json['emp_type']),
      position: json['position'] ,

    );
  }

  static EmploymentStatus _employmentStatusFromString(String? status) {
    switch (status?.toString()) {
      case 'Full Time':
        return EmploymentStatus.permanent;
      case 'Intern':
        return EmploymentStatus.intern;
      case 'Part Time':
        return EmploymentStatus.partTime;
      case 'parttime':
        return EmploymentStatus.partTime;
      default:
        return EmploymentStatus.permanent;
    }
  }
}
