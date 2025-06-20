class AttendanceModel {
  final String id;
  final String attendenceDate;
  final String attendenceStatus;
  final String empId;
  final String firstIn;
  final String lastOut;
  final String empName;
  final String empCode;
  final String profile;

  AttendanceModel({
    required this.id,
    required this.attendenceDate,
    required this.attendenceStatus,
    required this.empId,
    required this.firstIn,
    required this.lastOut,
    required this.empName,
    required this.empCode,
    required this.profile,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      attendenceDate: json['attendence_date'] ?? '',
      attendenceStatus: json['attendence_status'] ?? '',
      empId: json['emp_id'] ?? '',
      firstIn: json['first_in'] ?? '',
      lastOut: json['last_out'] ?? '',
      empName: json['emp_name'] ?? '',
      empCode: json['emp_code'] ?? '',
      profile: json['profile'] ?? '',
    );
  }
}
