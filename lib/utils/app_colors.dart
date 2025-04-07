import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - using deeper, more premium blue tones
  static const Color primary = Color(0xFF1E5AC2);         // Rich blue
  static const Color primaryLight = Color(0xFF3D7FEF);    // Lighter blue
  static const Color primaryDark = Color(0xFF0A2E6A);     // Deep navy
  
  // Accent colors - sophisticated gold and amber tones
  static const Color accent = Color(0xFFFFB74D);          // Gold amber
  static const Color accentLight = Color(0xFFFFD180);     // Light gold
  static const Color accentDark = Color(0xFFC88719);      // Deep gold
  
  // Background colors
  static const Color background = Colors.white;
  static const Color backgroundDark = Color(0xFFF2F5FA);  // Subtle light blue-gray
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure white
  
  // Text colors
  static const Color textPrimary = Color(0xFF202B41);     // Dark blue-gray
  static const Color textSecondary = Color(0xFF6B7B99);   // Medium slate
  static const Color textLight = Color(0xFFFFFFFF);       // White
  
  // Status colors - refined and professional
  static const Color success = Color(0xFF2E7D32);         // Deep green
  static const Color warning = Color(0xFFF29226);         // Warm amber
  static const Color error = Color(0xFFC62828);           // Deep red
  static const Color info = Color(0xFF1976D2);            // Strong blue
  
  // Neutral shades for UI elements
  static const Color neutral100 = Color(0xFFF7F9FC);      // Lightest gray
  static const Color neutral200 = Color(0xFFE3E8F0);      // Light gray
  static const Color neutral300 = Color(0xFFCDD5E1);      // Medium light gray
  static const Color neutral700 = Color(0xFF4F5D75);      // Medium dark gray
  static const Color neutral900 = Color(0xFF1A2336);      // Very dark gray/almost black
  
  // Shadow colors for depth
  static const Color shadowLight = Color(0x0F000000);     // Light shadow
  static const Color shadowMedium = Color(0x1A000000);    // Medium shadow
  static const Color shadowDark = Color(0x26000000);      // Dark shadow
  
  // Gradient colors - more sophisticated with 3 color stops
  static const List<Color> gradientPrimary = [
    Color(0xFF3D7FEF),   // Light blue
    Color(0xFF1E5AC2),   // Medium blue
    Color(0xFF0A2E6A),   // Dark blue
  ];
  
  static const List<Color> gradientAccent = [
    Color(0xFFFFD180),   // Light gold
    Color(0xFFFFB74D),   // Medium gold
    Color(0xFFC88719),   // Dark gold
  ];
  
  // Luxury gradient
  static const List<Color> gradientLuxury = [
    Color(0xFF0A2E6A),   // Deep blue
    Color(0xFF1E5AC2),   // Medium blue
    Color(0xFF0A2E6A),   // Deep blue
  ];
  
  // Premium card gradient
  static const List<Color> gradientPremiumCard = [
    Color(0xFF2D3A59),   // Dark blue-gray
    Color(0xFF1A2336),   // Very dark blue
    Color(0xFF13172E),   // Almost black blue
  ];
  
  // Gold card gradient
  static const List<Color> gradientGoldCard = [
    Color(0xFFBFA060),   // Medium gold
    Color(0xFF9E7E41),   // Darker gold
    Color(0xFF7F611F),   // Deep gold
  ];
  
  // Visa card gradient
  static const List<Color> gradientBlue = [
    Color(0xFF2196F3),   // Light blue
    Color(0xFF1565C0),   // Medium blue
    Color(0xFF0D47A1),   // Dark blue
  ];
  
  // Mastercard gradient
  static const List<Color> gradientOrange = [
    Color(0xFFFF9800),   // Light orange
    Color(0xFFF57C00),   // Medium orange
    Color(0xFFE65100),   // Dark orange
  ];
} 