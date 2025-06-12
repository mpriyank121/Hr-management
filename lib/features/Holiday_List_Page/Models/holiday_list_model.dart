class Holiday {
  final String holiday;
  final String holiday_date;
  final String? id;

  Holiday({required this.holiday, required this.holiday_date, this.id});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      holiday: json['holiday'] ?? '',
      holiday_date: json['holiday_date'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
