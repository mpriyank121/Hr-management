import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String defaultFont = 'Roboto';

  static TextStyle textStyle({
    Color color = AppColors.textPrimary,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: defaultFont,
    );
  }

  static final TextStyle heading = textStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle subText = textStyle(color: AppColors.textSecondary);
  static final TextStyle buttonText = textStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

class GreyTextStyles {
  static TextStyle small({
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

  static TextStyle medium({
    Color color = Colors.grey,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle large({
    Color color = Colors.grey,
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
