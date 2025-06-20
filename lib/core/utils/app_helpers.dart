import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelpers {
  static String calculateTotalHours(
      {required String clockIn, required String clockOut}) {
    if (clockIn.isEmpty || clockOut.isEmpty) {
      return '0';
    }

    try {
      final clockInTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(clockIn));
      final clockOutTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(clockOut));

      final start = DateTime(2020, 1, 1, clockInTime.hour, clockInTime.minute);
      final end = DateTime(2020, 1, 1, clockOutTime.hour, clockOutTime.minute);

      if (end.isBefore(start)) {
        // Handle overnight shifts if necessary
        return 'Invalid time';
      }

      final difference = end.difference(start);
      final hours = difference.inHours;
      final minutes = (difference.inMinutes % 60) / 60;

      return (hours + minutes).toStringAsFixed(2);
    } catch (e) {
      return '0';
    }
  }
} 