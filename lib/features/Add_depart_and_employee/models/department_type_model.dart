class DepartmentModel {
  final String id;
  final String department;

  DepartmentModel({
    required this.id,
    required this.department,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '', // ensure it's a String and fallback to empty
      department: json['department']?.toString() ?? '', // ensure it's a String and fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
    };
  }

  @override
  String toString() => 'DepartmentModel(id: $id, department: $department)';
}
