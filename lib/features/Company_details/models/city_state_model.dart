class CityState {
  final String city;
  final String state;

  CityState({required this.city, required this.state});

  factory CityState.fromJson(Map<String, dynamic> json) {
    return CityState(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
