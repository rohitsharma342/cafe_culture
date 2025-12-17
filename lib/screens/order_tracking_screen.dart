import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cafe_culture/controllers/order_controller.dart';
import 'package:cafe_culture/utils/constants.dart';
import 'package:cafe_culture/widgets/order_status_widget.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Get.snackbar(
                'Refreshed',
                'Order status updated',
                duration: Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final activeOrders = orderController.getActiveOrders();
        final orderHistory = orderController.getOrderHistory();

        if (!orderController.hasActiveOrders) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No current orders',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Your active orders will appear here',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Browse Menu'),
                ),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: AppConstants.primaryColor,
                  unselectedLabelColor: AppConstants.textSecondary,
                  indicatorColor: AppConstants.primaryColor,
                  tabs: [
                    Tab(
                      text: 'Active Orders (${activeOrders.length})',
                    ),
                    Tab(
                      text: 'History (${orderHistory.length})',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildActiveOrdersTab(context, activeOrders),
                    _buildOrderHistoryTab(context, orderHistory),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActiveOrdersTab(BuildContext context, List<dynamic> activeOrders) {
    if (activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No active orders',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Place an order to see it here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: activeOrders.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = activeOrders[index];
        return _buildOrderCard(context, order, isActive: true);
      },
    );
  }

  Widget _buildOrderHistoryTab(BuildContext context, List<dynamic> orderHistory) {
    if (orderHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No order history',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Your completed orders will appear here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: orderHistory.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orderHistory[index];
        return _buildOrderCard(context, order, isActive: false);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic order, {required bool isActive}) {
    final DateFormat timeFormat = DateFormat('MMM dd, yyyy - hh:mm a');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Ordered: ${timeFormat.format(order.orderTime)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (order.estimatedDelivery != null && isActive) ..[
              SizedBox(height: 4),
              Text(
                'Estimated delivery: ${timeFormat.format(order.estimatedDelivery)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
            SizedBox(height: 12),
            Text(
              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isActive) ...[
              SizedBox(height: 16),
              OrderStatusWidget(
                currentStatus: order.status,
                statuses: AppConstants.orderStatuses,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showOrderDetails(context, order);
                      },
                      icon: Icon(Icons.info_outline),
                      label: Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.primaryColor,
                        side: BorderSide(color: AppConstants.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showContactSupport(context);
                      },
                      icon: Icon(Icons.support_agent),
                      label: Text('Support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: AppConstants.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return Colors.blue;
      case 'Preparing':
        return Colors.orange;
      case 'Ready for Pickup':
        return Colors.purple;
      case 'Out for Delivery':
        return AppConstants.primaryColor;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(BuildContext context, dynamic order) {
    Get.dialog(
      AlertDialog(
        title: Text('Order Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            SizedBox(height: 8),
            Text('Customer: ${order.customerName}'),
            SizedBox(height: 8),
            Text('Delivery Address: ${order.deliveryAddress}'),
            SizedBox(height: 8),
            Text('Status: ${order.status}'),
            SizedBox(height: 8),
            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call Support'),
              subtitle: Text('+1 (555) 123-4567'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Calling Support',
                  'Opening phone app...',
                  duration: Duration(seconds: 2),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Live Chat'),
              subtitle: Text('Chat with our support team'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Live Chat',
                  'Opening chat support...',
                  duration: Duration(seconds: 2),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Support'),
              subtitle: Text('support@cafeculture.com'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Email Support',
                  'Opening email app...',
                  duration: Duration(seconds: 2),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}