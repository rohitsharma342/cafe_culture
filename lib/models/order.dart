import 'cart_item.dart';

enum OrderStatus {
  placed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled
}

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderTime;
  final OrderStatus status;
  final String? estimatedDeliveryTime;
  final String? deliveryAddress;
  
  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderTime,
    required this.status,
    this.estimatedDeliveryTime,
    this.deliveryAddress,
  });
  
  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}