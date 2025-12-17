import 'package:flutter/material.dart';
import 'package:cafe_culture/utils/constants.dart';

class OrderStatusWidget extends StatelessWidget {
  final String currentStatus;
  final List<String> statuses;

  const OrderStatusWidget({
    Key? key,
    required this.currentStatus,
    required this.statuses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentIndex = statuses.indexOf(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Status',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: List.generate(statuses.length, (index) {
            final bool isCompleted = index <= currentIndex;
            final bool isActive = index == currentIndex;
            
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? AppConstants.primaryColor
                                : Colors.grey.shade300,
                            border: Border.all(
                              color: isActive
                                  ? AppConstants.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        SizedBox(height: 8),
                        Text(
                          statuses[index],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isCompleted
                                ? AppConstants.primaryColor
                                : AppConstants.textSecondary,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (index < statuses.length - 1)
                    Container(
                      width: 20,
                      height: 2,
                      color: index < currentIndex
                          ? AppConstants.primaryColor
                          : Colors.grey.shade300,
                      margin: EdgeInsets.only(bottom: 32),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}