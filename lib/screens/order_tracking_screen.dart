import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../controllers/order_controller.dart';
import '../models/order.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<OrderController>(
        builder: (context, orderController, child) {
          final activeOrders = orderController.activeOrders;
          
          if (activeOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'No current orders',
                    style: AppConstants.titleStyle,
                  ),
                  SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Place an order to track its status',
                    style: AppConstants.subtitleStyle,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              return _OrderCard(order: activeOrders[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSupportDialog(context),
        backgroundColor: AppConstants.primaryColor,
        icon: const Icon(Icons.support_agent, color: Colors.white),
        label: const Text(
          'Contact Support',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: AppConstants.primaryColor),
                title: Text('Call Us'),
                subtitle: Text('+1 (555) 123-4567'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: AppConstants.primaryColor),
                title: Text('Email Us'),
                subtitle: Text('support@cafeculture.com'),
              ),
              ListTile(
                leading: Icon(Icons.chat, color: AppConstants.primaryColor),
                title: Text('Live Chat'),
                subtitle: Text('Available 24/7'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Order order;
  
  const _OrderCard({required this.order});
  
  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Order ${widget.order.id}',
              style: AppConstants.titleStyle.copyWith(fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(widget.order.orderTime),
                  style: AppConstants.subtitleStyle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                  style: AppConstants.priceStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          _buildStatusTimeline(),
          if (isExpanded) _buildOrderDetails(),
        ],
      ),
    );
  }
  
  Widget _buildStatusTimeline() {
    final statuses = [
      OrderStatus.placed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    
    final currentIndex = statuses.indexOf(widget.order.status);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      child: Column(
        children: [
          Row(
            children: statuses.map((status) {
              final index = statuses.indexOf(status);
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;
              
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppConstants.primaryColor
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: AppConstants.primaryColor,
                                width: 2,
                              )
                            : null,
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    if (index < statuses.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppConstants.primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            widget.order.statusText,
            style: AppConstants.titleStyle.copyWith(
              fontSize: 16,
              color: AppConstants.primaryColor,
            ),
          ),
          if (widget.order.estimatedDeliveryTime != null)
            Text(
              'Estimated delivery: ${widget.order.estimatedDeliveryTime}',
              style: AppConstants.subtitleStyle.copyWith(fontSize: 12),
            ),
        ],
      ),
    );
  }
  
  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.borderRadius),
          bottomRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: AppConstants.titleStyle,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...widget.order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.menuItem.name}',
                      style: AppConstants.subtitleStyle,
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: AppConstants.subtitleStyle,
                  ),
                ],
              ),
            ),
          ),
          if (widget.order.deliveryAddress != null) ...[
            const SizedBox(height: AppConstants.mediumPadding),
            const Text(
              'Delivery Address',
              style: AppConstants.titleStyle,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              widget.order.deliveryAddress!,
              style: AppConstants.subtitleStyle,
            ),
          ],
        ],
      ),
    );
  }
}