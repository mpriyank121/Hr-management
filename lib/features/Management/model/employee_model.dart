import 'dart:ui';

enum EmployeeStatus { notClockedIn, clockedIn, onLeave }
enum EmploymentStatus { permanent, contract, intern, partTime }

class Employee {
  final String name;
  final String role;
  final String department;
  final String hours;
  final Color color;
  final EmployeeStatus status;
  final String avatarUrl;
  final EmploymentStatus? employmentStatus;

  Employee({
    required this.name,
    required this.role,
    required this.department,
    required this.hours,
    required this.color,
    required this.status,
    required this.avatarUrl,
    this.employmentStatus,
  });
}
