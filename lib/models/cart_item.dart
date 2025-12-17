import 'package:cafe_culture/models/menu_item.dart';

class CartItem {
  final String id;
  final MenuItem menuItem;
  int quantity;
  final String selectedSize;
  final List<String> selectedExtras;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    this.selectedSize = '',
    this.selectedExtras = const [],
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  double get basePrice => menuItem.price;
  
  double get sizePrice {
    if (selectedSize == 'Large') return 0.50;
    if (selectedSize == 'Medium') return 0.25;
    return 0.0;
  }
  
  double get extrasPrice => selectedExtras.length * 0.50;
  
  double get unitPrice => basePrice + sizePrice + extrasPrice;
  
  double get itemTotal => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'] ?? '',
      selectedExtras: List<String>.from(json['selectedExtras'] ?? []),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedExtras': selectedExtras,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}