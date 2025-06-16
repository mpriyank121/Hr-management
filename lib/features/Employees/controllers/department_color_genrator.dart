
import 'dart:math';
import 'package:flutter/material.dart';

class DepartmentColorGenerator {
  static final Map<String, Color> _departmentColors = {};

  // Predefined attractive colors
  static final List<Color> _colorPalette = [
    const Color(0xFF1A96F0), // Blue
    const Color(0xFFF54336), // Red
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFE91E63), // Pink
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF009688), // Teal
    const Color(0xFFCDDC39), // Lime
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFFFC107), // Amber
    const Color(0xFF673AB7), // Deep Purple
  ];

  static Color getColorForDepartment(String department) {
    if (_departmentColors.containsKey(department)) {
      return _departmentColors[department]!;
    }

    // Generate color based on department name hash for consistency
    final hash = department.hashCode;
    final colorIndex = hash.abs() % _colorPalette.length;
    final color = _colorPalette[colorIndex];

    _departmentColors[department] = color;
    return color;
  }

  // Optional: Clear cache if needed
  static void clearCache() {
    _departmentColors.clear();
  }
}