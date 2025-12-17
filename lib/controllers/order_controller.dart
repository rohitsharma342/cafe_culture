import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderController extends ChangeNotifier {
  final List<Order> _orders = [];
  
  List<Order> get orders => _orders;
  List<Order> get activeOrders => _orders.where((order) => 
      order.status != OrderStatus.delivered && 
      order.status != OrderStatus.cancelled).toList();
  
  String placeOrder(List<CartItem> items, double totalAmount) {
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
    final order = Order(
      id: orderId,
      items: List.from(items),
      totalAmount: totalAmount,
      orderTime: DateTime.now(),
      status: OrderStatus.placed,
      estimatedDeliveryTime: _calculateEstimatedDeliveryTime(),
      deliveryAddress: '123 Main St, City, State 12345',
    );
    
    _orders.insert(0, order);
    notifyListeners();
    
    _simulateOrderProgress(orderId);
    
    return orderId;
  }
  
  String _calculateEstimatedDeliveryTime() {
    final estimatedTime = DateTime.now().add(const Duration(minutes: 25));
    return '${estimatedTime.hour.toString().padLeft(2, '0')}:${estimatedTime.minute.toString().padLeft(2, '0')}';
  }
  
  void _simulateOrderProgress(String orderId) async {
    await Future.delayed(const Duration(seconds: 30));
    _updateOrderStatus(orderId, OrderStatus.preparing);
    
    await Future.delayed(const Duration(minutes: 8));
    _updateOrderStatus(orderId, OrderStatus.ready);
    
    await Future.delayed(const Duration(minutes: 2));
    _updateOrderStatus(orderId, OrderStatus.outForDelivery);
    
    await Future.delayed(const Duration(minutes: 15));
    _updateOrderStatus(orderId, OrderStatus.delivered);
  }
  
  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      final oldOrder = _orders[orderIndex];
      _orders[orderIndex] = Order(
        id: oldOrder.id,
        items: oldOrder.items,
        totalAmount: oldOrder.totalAmount,
        orderTime: oldOrder.orderTime,
        status: newStatus,
        estimatedDeliveryTime: oldOrder.estimatedDeliveryTime,
        deliveryAddress: oldOrder.deliveryAddress,
      );
      notifyListeners();
    }
  }
  
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}