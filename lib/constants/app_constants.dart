import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  
  static const String appName = 'Cafe Culture';
  static const String tagline = 'Made With BrainBox';
  
  static const double borderRadius = 12.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: lightTextColor,
  );
  
  static const TextStyle priceStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
}