class Position {
  final String id;
  final String position;

  Position({required this.id, required this.position});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] ?? '',
      position: json['position'] ?? '',
    );
  }
}
