import 'package:flutter/material.dart';
import 'package:hr_management/features/Management/Widgets/bordered_container.dart';

import '../../config/font_style.dart';

class DateRangeSelectorWidget extends StatefulWidget {
  final void Function(DateTime start, DateTime end)? onDateRangeSelected;
  const DateRangeSelectorWidget({Key? key, this.onDateRangeSelected}) : super(key: key);

  @override
  _DateRangeSelectorWidgetState createState() => _DateRangeSelectorWidgetState();
}

class _DateRangeSelectorWidgetState extends State<DateRangeSelectorWidget> {
  DateTimeRange? selectedDateRange;
  String displayText = "This Month";

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        displayText = _formatDateRange(picked);
      });
      if (widget.onDateRangeSelected != null) {
        widget.onDateRangeSelected!(picked.start, picked.end);
      }
    }
  }

  String _formatDateRange(DateTimeRange range) {
    final startDate = "${range.start.day}/${range.start.month}/${range.start.year}";
    final endDate = "${range.end.day}/${range.end.month}/${range.end.year}";
    return "$startDate - $endDate";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: BorderedContainer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayText,
              style: FontStyles.subTextStyle(),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}