class OrgLeave {
  final String leaveID;
  final String totalAnnualLeaves;
  final String leaveName;

  OrgLeave({
    required this.leaveID,
    required this.totalAnnualLeaves,
    required this.leaveName,
  });

  factory OrgLeave.fromJson(Map<String, dynamic> json) {
    return OrgLeave(
      leaveID: json['leaveID'] ?? '',
      totalAnnualLeaves: json['total_annual_leaves'] ?? '',
      leaveName: json['leave_name'] ?? '',
    );
  }
}