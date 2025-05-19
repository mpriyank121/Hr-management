class LeaveModel {
  final String leaveName;
  final String startDate;
  final String endDate;
  final String status;
  final String comment;
  final String resson;

  LeaveModel({
    required this.leaveName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.comment,
    required this.resson
  });

  // Factory constructor to create an object from JSON
  static List<LeaveModel> dummyLeaves = [
    LeaveModel(
      leaveName: 'Sick Leave',
      startDate: '2025-05-10',
      endDate: '2025-05-12',
      status: 'Approved',
      comment: 'Take rest and recover soon.',
      resson: 'Fever and weakness',
    ),
    LeaveModel(
      leaveName: 'Casual Leave',
      startDate: '2025-05-15',
      endDate: '2025-05-15',
      status: 'Pending',
      comment: '',
      resson: 'Family function',
    ),
    LeaveModel(
      leaveName: 'Work From Home',
      startDate: '2025-05-18',
      endDate: '2025-05-19',
      status: 'Rejected',
      comment: 'Work from home not permitted during sprint planning.',
      resson: 'Internet issue at home',
    ),
    LeaveModel(
      leaveName: 'Annual Leave',
      startDate: '2025-06-01',
      endDate: '2025-06-07',
      status: 'Approved',
      comment: 'Enjoy your vacation!',
      resson: 'Vacation with family',
    ),
  ];
}
