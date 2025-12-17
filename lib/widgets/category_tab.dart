import 'package:flutter/material.dart';
import 'package:cafe_culture/utils/constants.dart';

class CategoryTab extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppConstants.primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppConstants.textSecondary,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}