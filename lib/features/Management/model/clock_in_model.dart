
class ClockInModel {
  final String empId;
  final String empName;
  final String empCode;
  final String? firstIn;
  final String? profileUrl;
  final String? lastOut;
  final String? totalHours;
  final String? date;


  ClockInModel({
    required this.empId,
    required this.empName,
    required this.empCode,
    this.firstIn,
    this.profileUrl,
    this.lastOut,
    this.totalHours,
    this.date

  });

  factory ClockInModel.fromJson(Map<String, dynamic> json) {
    return ClockInModel(
        empId: json['emp_id'] ?? '',
        empName: json['emp_name'] ?? '',
        empCode: json['emp_code'] ?? '',
        firstIn: json['first_in'] ?? '',
        profileUrl: json['profile'] ?? '',
      lastOut: json['last_out'] ?? '',
      totalHours: json["time_taken"] ?? '',
      date: json['attendence_date'] ?? ''
    );
  }
}