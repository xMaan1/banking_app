import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2D9CDB);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);
  
  // Accent colors
  static const Color accent = Color(0xFF6FCF97);
  static const Color accentLight = Color(0xFF4FC3F7);
  static const Color accentDark = Color(0xFF0288D1);
  
  // Background colors
  static const Color background = Colors.white;
  static const Color backgroundDark = Color(0xFFE8EDF2);
  static const Color backgroundLight = Color(0xFFF2F2F2);
  
  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF828282);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFEB5757);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient colors
  static const List<Color> gradientPrimary = [primaryLight, primary, primaryDark];
  static const List<Color> gradientAccent = [accentLight, accent, accentDark];
} 