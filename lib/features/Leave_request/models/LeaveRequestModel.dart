class LeaveRequestModel {
  final String leaveName;
  final String leaveId;
  final String empName;
  final String leaveStartDate;
  final String leaveEndDate;
  late final String status;
  final String comment;
  final String reason;
  final String statusId;
  final String applyDate;
  final String Department;
  final String profileImageUrl;
  final String empCode;

  LeaveRequestModel({
    required this.leaveName,
    required this.leaveId,
    required this.empName,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.status,
    required this.comment,
    required this.reason,
    required this.statusId,
    required this.applyDate,
    required this.Department,
    required this.profileImageUrl,
    required this.empCode
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      leaveName: json['leave_name'],
      leaveId: json['leave_id'],
      empName: json['emp_name'],
      leaveStartDate: json['leave_start_date'],
      leaveEndDate: json['leave_end_date'],
      status: json['status'],
      comment: json['comment'],
      reason: json['resson'],
      statusId: json['status_id'],
      Department: json['department'],
      profileImageUrl:json['emp_profile'],
      applyDate: json['apply_date'],
      empCode: json['emp_code']


    );
  }
}
