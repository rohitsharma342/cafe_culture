import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_culture/controllers/cart_controller.dart';
import 'package:cafe_culture/controllers/order_controller.dart';
import 'package:cafe_culture/utils/constants.dart';
import 'package:cafe_culture/widgets/cart_item_widget.dart';
import 'package:cafe_culture/screens/order_tracking_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          Obx(() => cartController.isEmpty
              ? Container()
              : TextButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('Clear Cart'),
                        content: Text('Are you sure you want to remove all items from your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartController.clearCart();
                              Get.back();
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.red),
                  ),
                )),
        ],
      ),
      body: Obx(() {
        if (cartController.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Add some delicious items to get started!',
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

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    cartItem: cartController.cartItems[index],
                    onQuantityChanged: (newQuantity) {
                      cartController.updateQuantity(
                        cartController.cartItems[index].id,
                        newQuantity,
                      );
                    },
                    onRemove: () {
                      cartController.removeFromCart(
                        cartController.cartItems[index].id,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Items:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '${cartController.cartCount}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\$${cartController.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Obx(() => ElevatedButton(
                        onPressed: orderController.isLoading
                            ? null
                            : () => _proceedToPayment(context),
                        child: orderController.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Processing...'),
                                ],
                              )
                            : Text('Proceed to Payment'),
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _proceedToPayment(BuildContext context) async {
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary:'),
            SizedBox(height: 8),
            ...cartController.cartItems.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.menuItem.name}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '\$${item.itemTotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$${cartController.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              
              final success = await orderController.placeOrder(
                items: cartController.cartItems,
                totalAmount: cartController.totalAmount,
                customerName: 'John Doe',
                deliveryAddress: '123 Main St, City',
              );
              
              if (success) {
                cartController.clearCart();
                Get.off(() => OrderTrackingScreen());
              }
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }
}