import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'Leave_card.dart';

class AttendanceCalendar extends StatefulWidget {
  final void Function(DateTime)? onDateSelected;
  final bool popOnDateTap;
  final void Function(int year, int month)? onMonthChanged;

  const AttendanceCalendar({
    super.key,
    this.onDateSelected,
    this.onMonthChanged,
    this.popOnDateTap = false,
  });

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  final Map<DateTime, String> dummyAttendance = {
    DateTime.now().subtract(const Duration(days: 1)): "P",
    DateTime.now(): "A",
    DateTime.now().subtract(const Duration(days: 3)): "H",
  };

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

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

    widget.onMonthChanged?.call(newYear, newMonth);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return const Color(0xFFB2DFDB); // Present
      case "A":
        return const Color(0xFFE57373); // Absent
      case "H":
        return const Color(0xFF64B5F6); // Leave/Holiday
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
          // Header
          Container(
            width: screenWidth * 0.9,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: SvgPicture.asset('assets/images/chevron-u.svg'),
                ),
                Text(
                  "${DateFormat.MMM().format(DateTime(selectedYear, selectedMonth))} $selectedYear",
                  style: const TextStyle(
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
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child:  Row(
                  children: [
                    LeaveCard(
                      title: "Present", count: '',
                    ),
                    LeaveCard(
                      title: "Absent",
                      backgroundColor: Color(0x19C13C0B),
                      borderColor: Color(0xFFC13C0B), count: '',
                    ),
                    LeaveCard(
                      title: "Half Day",
                      backgroundColor: Color(0x1933B2E9),
                      borderColor: Color(0xFF33B2E9), count: '',
                    ),
                  ],
                )),
          ),

          const SizedBox(height: 12),

          // Calendar
          Card(
            child: Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(color: Colors.white),
              child: TableCalendar(
                firstDay: DateTime(2000, 1, 1),
                lastDay: DateTime(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (_) => false,
                availableGestures: AvailableGestures.none,
                enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  widget.onDateSelected?.call(selectedDay);

                  if (widget.popOnDateTap) {
                    Navigator.pop(context);
                  }
                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: true,
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    DateTime normalizedDate = _normalizeDate(date);
                    String status = dummyAttendance[normalizedDate] ?? "N";

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(
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
