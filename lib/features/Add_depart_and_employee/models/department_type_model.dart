class DepartmentModel {
  final String id;
  final String department;
  final String? supervisor;
  final String? workPattern;

  DepartmentModel({
    required this.id,
    required this.department,
    this.supervisor,
    this.workPattern,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '', // ensure it's a String and fallback to empty
      department: json['department']?.toString() ?? '', // ensure it's a String and fallback
      supervisor: json['supervisor']?.toString(),
      workPattern: json['work_pattern']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
      'supervisor': supervisor,
      'work_pattern': workPattern,
    };
  }

  @override
  String toString() => 'DepartmentModel(id: $id, department: $department, supervisor: $supervisor, workPattern: $workPattern)';
}
