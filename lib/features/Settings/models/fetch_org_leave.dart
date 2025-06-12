class OrgLeave {
  final String leaveID;
  final String totalAnnualLeaves;
  final String leaveName;
  final String? id;
  final String? year;

  OrgLeave({
    required this.leaveID,
    required this.totalAnnualLeaves,
    required this.leaveName,
    this.id,
    this.year
  });

  factory OrgLeave.fromJson(Map<String, dynamic> json) {
    return OrgLeave(
      id: json["id"] ?? '',
      leaveID: json['leaveID'] ?? '',
      totalAnnualLeaves: json['total_annual_leaves'] ?? '',
      leaveName: json['leave_name'] ?? '',
      year: json['year'] ?? ""
    );
  }
}