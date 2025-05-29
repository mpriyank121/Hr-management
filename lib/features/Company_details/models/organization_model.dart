class OrganizationModel {
  final String orgName;
  final String industryType;
  final String phone;
  final String email;
  final String pincode;
  String state; // mutable so we can set it later
  String city;  // mutable so we can set it later
  final String address;
  final String website;
  final String gstNo;
  final String panNumber;
  final String panImageUrl;
  final String orgLogo;
  final String? logoUrl;
  final String? orgUrl;
  final String? stateId;
  final String? cityId;

  OrganizationModel({
    required this.orgName,
    required this.industryType,
    required this.phone,
    required this.email,
    required this.pincode,
    required this.state,
    required this.city,
    required this.address,
    required this.website,
    required this.gstNo,
    required this.panNumber,
    required this.panImageUrl,
    required this.orgLogo,
    this.stateId,
    this.cityId,
    this.logoUrl,
    this.orgUrl,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      orgName: json['org_name'] ?? '',
      industryType: json['industry_type'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state']?? "", // to be fetched later
      city: json['city']?? "",  // to be fetched later
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      gstNo: json['gst_no'] ?? '',
      panNumber: json['pan_number'] ?? '',
      panImageUrl: 'https://img.bookchor.com/${json['pan_image']}',
      orgLogo: json['org_logo'] ?? '',
      logoUrl: 'https://img.bookchor.com/${json['org_logo']}',
      orgUrl: json['website'],
      stateId: json['state_id']?? "",
      cityId: json['city_id']?? '',
    );
  }
}
