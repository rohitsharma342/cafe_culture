import 'package:cafe_culture/models/cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String customerName;
  final String deliveryAddress;
  final DateTime orderTime;
  final DateTime? estimatedDelivery;
  String status;
  final String paymentMethod;
  final String? specialInstructions;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.customerName,
    required this.deliveryAddress,
    DateTime? orderTime,
    this.estimatedDelivery,
    this.status = 'Order Placed',
    this.paymentMethod = 'Cash on Delivery',
    this.specialInstructions,
  }) : orderTime = orderTime ?? DateTime.now();

  bool get isActive {
    return status != 'Delivered' && status != 'Cancelled';
  }

  bool get isCompleted {
    return status == 'Delivered';
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      customerName: json['customerName'],
      deliveryAddress: json['deliveryAddress'],
      orderTime: DateTime.parse(json['orderTime']),
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
      status: json['status'],
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,
      'orderTime': orderTime.toIso8601String(),
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
      'specialInstructions': specialInstructions,
    };
  }
}