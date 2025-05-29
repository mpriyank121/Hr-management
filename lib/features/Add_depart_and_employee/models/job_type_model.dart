class JobType {
  final String id;
  final String type;

  JobType({required this.id, required this.type});

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
