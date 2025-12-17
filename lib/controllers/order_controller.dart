import 'dart:async';
import 'package:get/get.dart';
import 'package:cafe_culture/models/order.dart';
import 'package:cafe_culture/models/cart_item.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = <Order>[].obs;
  final RxBool _isLoading = false.obs;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading.value;
  bool get hasActiveOrders => _orders.any((order) => order.isActive);

  List<Order> getActiveOrders() {
    return _orders.where((order) => order.isActive).toList();
  }

  List<Order> getOrderHistory() {
    return _orders.where((order) => order.isCompleted).toList();
  }

  Future<bool> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String customerName,
    required String deliveryAddress,
    String paymentMethod = 'Cash on Delivery',
    String? specialInstructions,
  }) async {
    try {
      _isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      final String orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final DateTime estimatedDelivery = DateTime.now().add(Duration(minutes: 30));

      final Order newOrder = Order(
        id: orderId,
        items: List.from(items),
        totalAmount: totalAmount,
        customerName: customerName,
        deliveryAddress: deliveryAddress,
        estimatedDelivery: estimatedDelivery,
        paymentMethod: paymentMethod,
        specialInstructions: specialInstructions,
      );

      _orders.add(newOrder);

      // Start order status simulation
      _simulateOrderProgress(orderId);

      Get.snackbar(
        'Order Placed Successfully!',
        'Your order #$orderId has been placed',
        duration: Duration(seconds: 3),
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Order Failed',
        'Failed to place order. Please try again.',
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void _simulateOrderProgress(String orderId) {
    final statuses = [
      'Order Placed',
      'Preparing',
      'Ready for Pickup',
      'Out for Delivery',
      'Delivered',
    ];

    int currentStatusIndex = 0;

    Timer.periodic(Duration(seconds: 10), (timer) {
      if (currentStatusIndex < statuses.length - 1) {
        currentStatusIndex++;
        updateOrderStatus(orderId, statuses[currentStatusIndex]);
      } else {
        timer.cancel();
      }
    });
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex].status = newStatus;
      _orders.refresh();

      Get.snackbar(
        'Order Update',
        'Order #$orderId is now $newStatus',
        duration: Duration(seconds: 2),
      );
    }
  }

  Order? getOrder(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void cancelOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      if (_orders[orderIndex].status == 'Order Placed' || 
          _orders[orderIndex].status == 'Preparing') {
        _orders[orderIndex].status = 'Cancelled';
        _orders.refresh();
        
        Get.snackbar(
          'Order Cancelled',
          'Order #$orderId has been cancelled',
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Cannot Cancel',
          'Order cannot be cancelled at this stage',
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  void refreshOrders() {
    // Simulate refreshing orders from server
    Get.snackbar(
      'Orders Refreshed',
      'Order status updated',
      duration: Duration(seconds: 1),
    );
  }
}