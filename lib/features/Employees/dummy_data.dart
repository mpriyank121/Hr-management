import 'package:flutter/material.dart';

import '../Management/model/employee_model.dart';

class DummyData {
  static List<Employee> dummyEmployees = [
    // Product Department
    Employee(
      name: 'William Brown',
      role: 'Product Manager',
      department: 'Product',
      hours: '29.6h',
      color: Colors.green,
      status: EmployeeStatus.notClockedIn,
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      employmentStatus: EmploymentStatus.intern,


    ),
    Employee(
      name: 'Sophia Miller',
      role: 'Product Analyst',
      department: 'Product',
      hours: '28.1h',
      color: Colors.green,
      status: EmployeeStatus.clockedIn,
      avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      employmentStatus: EmploymentStatus.permanent,

    ),

    // Engineering Department
    Employee(
      name: 'Elizabeth Turner',
      role: 'Engineer',
      department: 'Engineering',
      hours: '25.3h',
      color: Colors.green,
      status: EmployeeStatus.clockedIn,
      avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      employmentStatus: EmploymentStatus.contract,

    ),
    Employee(
      name: 'James Wilson',
      role: 'DevOps Engineer',
      department: 'Engineering',
      hours: '24.7h',
      color: Colors.green,
      status: EmployeeStatus.notClockedIn,
      avatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
      employmentStatus: EmploymentStatus.permanent,

    ),

    // UI/UX Department
    Employee(
      name: 'Emma Brown',
      role: 'UI/UX Designer',
      department: 'UI/UX',
      hours: '21.2h',
      color: Colors.red,
      status: EmployeeStatus.onLeave,
      avatarUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
      employmentStatus: EmploymentStatus.partTime,

    ),
    Employee(
      name: 'Lucas Green',
      role: 'Visual Designer',
      department: 'UI/UX',
      hours: '20.5h',
      color: Colors.green,
      status: EmployeeStatus.clockedIn,
      avatarUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
      employmentStatus: EmploymentStatus.permanent,

    ),
  ];

  // Grouped by Department
  static Map<String, List<Employee>> get departmentWiseEmployees {
    Map<String, List<Employee>> map = {};
    for (var e in dummyEmployees) {
      map.putIfAbsent(e.department, () => []).add(e);
    }
    return map;
  }
}
