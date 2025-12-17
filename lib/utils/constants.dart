import 'package:flutter/material.dart';
import 'package:cafe_culture/constants/app_constants.dart';

class AppConstants {
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  
  static const String appName = 'Cafe Culture';
  static const String tagline = 'Made With BrainBox';
  
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  
  static const List<String> categories = [
    'All',
    'Coffee',
    'Tea',
    'Pastries',
    'Sandwiches',
    'Desserts',
  ];
  
  static const List<String> orderStatuses = [
    'Order Placed',
    'Preparing',
    'Ready for Pickup',
    'Out for Delivery',
    'Delivered',
  ];
}