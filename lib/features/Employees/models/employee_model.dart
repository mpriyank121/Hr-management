enum EmploymentStatus { permanent, contract, intern, partTime }

class Employee {
  final String id;
  final String name;
  final String department;
  final String avatarUrl;
  final EmploymentStatus employmentStatus;
  final String position;
  final String totalemployees;
  final String empCode;
  final String gender;
  final String doj;
  final String phone;
  final String email;
  final String userRole;
  final String empType;
  final String salary;
  final String workingHours;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.avatarUrl,
    required this.employmentStatus,
    required this.position,
    required this.totalemployees,
    required this.empCode,
    required this.gender,
    required this.doj,
    required this.phone,
    required this.email,
    required this.userRole,
    required this.empType,
    required this.salary,
    required this.workingHours
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    print('📝 Parsing employee list data: $json');
    return Employee(
      id: json['id']?.toString() ?? json['emp_id']?.toString() ?? '',
      name: json['emp_name'] ?? '',
      department: json['department'] ?? '',
      avatarUrl: 'https://img.bookchor.com/${json['emp_image'] ?? ''}',
      employmentStatus: _employmentStatusFromString(json['emp_type']),
      position: json['position'] ?? '',
      totalemployees: json['total_emp']?.toString() ?? '',
      empCode: json['emp_code'] ?? '',
      gender: json['gender'] ?? '',
      doj: json['doj'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      userRole: json['user_role'] ?? '',
      empType: json['emp_type'].toString() ?? '',
      salary:  json['total_salary'].toString() ?? '',
      workingHours: json['emp_working_hours'].toString() ?? '',

    );
  }
}
   EmploymentStatus _employmentStatusFromString(String? status) {
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

