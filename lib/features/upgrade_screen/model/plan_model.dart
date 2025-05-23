class Plan {
  final String id;
  final String name;
  final String monthlyPrice;
  final String yearlyPrice;
  final String teamSize;
  final String description;
  final int discountPercentage;
  final List<Service> services;

  Plan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.teamSize,
    required this.description,
    required this.discountPercentage,
    required this.services,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    List<Service> services = servicesList.map((i) => Service.fromJson(i)).toList();

    return Plan(
      id: json['id'],
      name: json['name'],
      monthlyPrice: json['monthly_price'],
      yearlyPrice: json['yearly_price'],
      teamSize: json['team_size'],
      description: json['description'],
      discountPercentage: json['discount_percentage'],
      services: services,
    );
  }
}

class Service {
  final String name;
  final String description;

  Service({required this.name, required this.description});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      description: json['description'],
    );
  }
}
