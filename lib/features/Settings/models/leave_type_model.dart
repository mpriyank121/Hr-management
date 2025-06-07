class LeaveTypeModel {
  final String id;
  final String leaveName;

  LeaveTypeModel({required this.id, required this.leaveName});

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'],
      leaveName: json['leave_name'],
    );
  }

}
