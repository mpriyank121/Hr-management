class LeaveModel {
  final String? leaveName;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? comment;
  final String? resson;
  final String? notes;

  LeaveModel({
    this.leaveName,
    this.startDate,
    this.endDate,
    this.status,
    this.comment,
    this.resson,
    this.notes
  });

  // Factory constructor to create an object from JSON
  static List<LeaveModel> Leaves = [
    LeaveModel(
      leaveName: 'leave_name',
      startDate: 'leave_start_date',
      endDate: 'leave_end_date',
      status: 'status',
      comment: 'comment',
      resson: 'resson',
      notes: ''
    ),

  ];
}
