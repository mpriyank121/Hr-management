import 'package:flutter/material.dart';

class FontStyles {
  static TextStyle headingStyle({
    Color color = Colors.black,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle subHeadingStyle({
    Color color = Colors.black87,
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle subTextStyle({
    Color color = Colors.grey,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
