import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CategoryTab extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;
  
  const CategoryTab({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppConstants.smallPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.mediumPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : AppConstants.textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}