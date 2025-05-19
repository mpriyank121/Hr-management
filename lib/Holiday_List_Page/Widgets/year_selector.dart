import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Configuration/app_colors.dart';


class YearMonthSelector extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final Function(int, int) onDateChanged;
  final bool showMonth; // ✅ NEW

  const YearMonthSelector({
    super.key,
    required this.initialYear,
    required this.initialMonth,
    required this.onDateChanged,
    this.showMonth = true, // ✅ default true
  });

  @override
  _YearMonthSelectorState createState() => _YearMonthSelectorState();
}

class _YearMonthSelectorState extends State<YearMonthSelector> {
  late int selectedYear;
  late int selectedMonth;

  final List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
  }

  void changeMonth(int step) {
    if (!widget.showMonth) return;

    setState(() {
      selectedMonth += step;

      if (selectedMonth < 1) {
        selectedMonth = 12;
        selectedYear--;
      } else if (selectedMonth > 12) {
        selectedMonth = 1;
        selectedYear++;
      }
    });
    widget.onDateChanged(selectedYear, selectedMonth);
  }

  void changeYear(int step) {
    setState(() {
      selectedYear += step;
    });
    widget.onDateChanged(selectedYear, selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.85,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () =>
            widget.showMonth ? changeMonth(-1) : changeYear(-1),
            icon: SvgPicture.asset('assets/images/chevron-u.svg'),
          ),
          Text(
            widget.showMonth
                ? "${months[selectedMonth - 1]} $selectedYear"
                : "$selectedYear",
            style: const TextStyle(
              color: Color(0xFFF25922),
              fontSize: 20,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () =>
            widget.showMonth ? changeMonth(1) : changeYear(1),
            icon: SvgPicture.asset('assets/images/chevron-up.svg'),
          ),
        ],
      ),
    );
  }
}

