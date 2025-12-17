import 'package:get/get.dart';
import 'package:cafe_culture/models/cart_item.dart';
import 'package:cafe_culture/models/menu_item.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  
  List<CartItem> get cartItems => _cartItems;
  
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _cartItems.fold(0.0, (sum, item) => sum + item.itemTotal);
  
  bool get isEmpty => _cartItems.isEmpty;

  void addToCart({
    required MenuItem menuItem,
    required int quantity,
    String selectedSize = '',
    List<String> selectedExtras = const [],
  }) {
    final String itemId = '${menuItem.id}_${selectedSize}_${selectedExtras.join('_')}';
    
    final existingItemIndex = _cartItems.indexWhere((item) => item.id == itemId);
    
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += quantity;
      _cartItems.refresh();
    } else {
      final cartItem = CartItem(
        id: itemId,
        menuItem: menuItem,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedExtras: selectedExtras,
      );
      _cartItems.add(cartItem);
    }
    
    Get.snackbar(
      'Added to Cart',
      '${menuItem.name} has been added to your cart',
      duration: Duration(seconds: 2),
    );
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _cartItems[itemIndex].quantity = newQuantity;
      _cartItems.refresh();
    }
  }

  void removeFromCart(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    Get.snackbar(
      'Item Removed',
      'Item has been removed from your cart',
      duration: Duration(seconds: 2),
    );
  }

  void clearCart() {
    _cartItems.clear();
    Get.snackbar(
      'Cart Cleared',
      'All items have been removed from your cart',
      duration: Duration(seconds: 2),
    );
  }

  CartItem? getCartItem(String itemId) {
    try {
      return _cartItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
}