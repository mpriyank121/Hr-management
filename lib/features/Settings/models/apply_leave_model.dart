class ApplyLeaveRequest {
  final String type;
  final String empMob;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String note;

  ApplyLeaveRequest({
    required this.type,
    required this.empMob,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.note,
  });

  Map<String, String> toMap() {
    return {
      'type': type,
      'emp_mob': empMob,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'note': note,
    };
  }
}

