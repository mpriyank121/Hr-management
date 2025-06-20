import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hr_management/core/encryption/encryption_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../features/Attendence/Models/employee_attendance_model.dart';
import '../../features/Attendence/controllers/attendance_controller.dart';
import '../../features/Attendence/services/employee_attendence_service.dart';

class AttendanceCalendar extends StatefulWidget {
  final String employeeId;
  final Function(
      DateTime,
      String,
      String,
      )? onDateSelected;
  final bool popOnDateTap;
  final void Function(int year, int month)? onMonthChanged;
  final void Function(Map<String, int> statusCount)? onStatusCountChanged;

  const AttendanceCalendar({
    super.key,
    this.onDateSelected,
    this.onMonthChanged,
    this.popOnDateTap = false,
    required this.employeeId,
    this.onStatusCountChanged, // 👈 default is false
  });

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  Map<DateTime, Map<String, String>> attendanceData = {};
  final AttendanceController controller = Get.put(AttendanceController());
  Map<String, int> statusCount = {"present": 0, "absent": 0, "halfday": 0};

// ✅ FIXED

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  /// ✅ Normalize Date (removes time part)
  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day); // ✅ FIXED

  /// ✅ Fetch Attendance Data
  Future<void> _loadAttendanceData() async {
    try {
      // Get current month start and end date
      final startOfMonth = DateTime(selectedYear, selectedMonth, 1);
      final endOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);
      final dateFormat = DateFormat('yyyy-MM-dd');
      final startDate = dateFormat.format(startOfMonth);
      final endDate = dateFormat.format(endOfMonth);

      debugPrint("Fetching attendance from: $startDate to $endDate");

      // Get the encrypted mobile from your user/session (replace this with your actual logic)
      String mob = '50a44a42a42a43a49a50a46a43a43a105'; // <-- Replace with actual value

      List<AttendanceModel> result = await AttendanceService.fetchAttendance(
        type: '102a100a115a64a115a115a100a109a99a96a109a98a100a99',
        mob: mob,
        startDate: startDate,
        endDate: endDate,
        id: EncryptionHelper.encryptString(widget.employeeId), // <-- Use the employeeId passed to the widget
      );

      if (mounted) {
        setState(() {
          attendanceData = {
            for (var record in result)
              _normalizeDate(DateTime.parse(record.attendenceDate)): {
                "status": record.attendenceStatus,
                "first_in": record.firstIn,
                "last_out": record.lastOut,
              }
          };
          statusCount = {
            "present": result.where((e) => e.attendenceStatus == "P").length,
            "absent": result.where((e) => e.attendenceStatus == "A").length,
            "halfday": result.where((e) => e.attendenceStatus == "H").length,
          };
          widget.onStatusCountChanged?.call(statusCount);
        });
      }

      print("✅ Attendance Data Loaded: $attendanceData");
    } catch (e) {
      print("🔴 Error fetching attendance: $e");
    }
  }



  /// ✅ Month Navigation (restrict future)
  void _changeMonth(int step) {
    int newMonth = selectedMonth + step;
    int newYear = selectedYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    DateTime newFocusedDay = DateTime(newYear, newMonth);
    if (newFocusedDay.isAfter(DateTime.now())) return;

    setState(() {
      selectedMonth = newMonth;
      selectedYear = newYear;
      _focusedDay = newFocusedDay;
    });
    print("priya$newMonth");
    print("$newYear");

    widget.onMonthChanged?.call(selectedYear, selectedMonth);
    _loadAttendanceData();

// ✅ FIXED
  }

  /// ✅ Get Color Based on Attendance Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return AppColors.primary; // Present
      case "A":
        return Color(0xFFE57373); // Absent
      case "H":
        return Color(0xFF64B5F6); // Work/Leave
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: SvgPicture.asset('assets/images/chevron-u.svg'),
                ),
                Text(
                  "${DateFormat.MMM().format(DateTime(selectedYear, selectedMonth))} $selectedYear",
                  style: TextStyle(
                    color: Color(0xFFF25922),
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: SvgPicture.asset('assets/images/chevron-up.svg'),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.012),
          Card(
            child: Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime(2000, 1, 1),
                lastDay: DateTime(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (_) => false,


                availableGestures: AvailableGestures.none,
                enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  DateTime normalizedDate = _normalizeDate(selectedDay); // ✅ FIXED
                  Map<String, String>? record = attendanceData[normalizedDate];

                  String firstIn = (record?["first_in"]?.trim().isNotEmpty == true) ? record!["first_in"]! : "N/A";
                  String lastOut = (record?["last_out"]?.trim().isNotEmpty == true) ? record!["last_out"]! : "N/A";

                  widget.onDateSelected?.call(
                    selectedDay,
                    firstIn,
                    lastOut,
                  );



                  if (widget.popOnDateTap) {
                    Navigator.pop(context); // <-- this closes the dialog/screen
                  }                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false,

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  defaultTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    DateTime normalizedDate = _normalizeDate(date);
                    String status = attendanceData[normalizedDate]?['status'] ?? "N";
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),

                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
