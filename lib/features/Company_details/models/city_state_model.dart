class CityState {
  final String city;
  final String state;
  final String cityId;
  final String stateId;

  CityState({required this.city, required this.state,required this.cityId,required this.stateId});

  factory CityState.fromJson(Map<String, dynamic> json) {
    return CityState(
      cityId: json['cityID']?? '',
      stateId: json['stateId']?? '',
      city: json['cityID'] ?? '',
      state: json['stateId'] ?? '',
    );
  }
}
