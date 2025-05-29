class WorkPattern {
  final String id;
  final String workPattern;

  WorkPattern({required this.id, required this.workPattern});

  factory WorkPattern.fromJson(Map<String, dynamic> json) {
    return WorkPattern(
      id: json['id'],
      workPattern: json['work_pattern'],
    );
  }
}
