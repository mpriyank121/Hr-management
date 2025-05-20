class Industry {
  final String id;
  final String industry;

  Industry({required this.id, required this.industry});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'],
      industry: json['industry'],
    );
  }
}
