import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  bool get isEmpty => _items.isEmpty;
  
  void addItem(MenuItem menuItem, int quantity, Map<String, CustomizationOption> customizations) {
    final existingIndex = _items.indexWhere((item) => 
        item.menuItem.id == menuItem.id && 
        _compareCustomizations(item.selectedCustomizations, customizations));
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        menuItem: menuItem,
        quantity: quantity,
        selectedCustomizations: customizations,
      ));
    }
    notifyListeners();
  }
  
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      _items[index].quantity = newQuantity;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }
  
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  bool _compareCustomizations(Map<String, CustomizationOption> a, Map<String, CustomizationOption> b) {
    if (a.length != b.length) return false;
    for (String key in a.keys) {
      if (!b.containsKey(key) || a[key]!.name != b[key]!.name) return false;
    }
    return true;
  }
}