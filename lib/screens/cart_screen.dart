import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<CartController>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'Your cart is empty',
                    style: AppConstants.titleStyle,
                  ),
                  SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Add some items to get started',
                    style: AppConstants.subtitleStyle,
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.mediumPadding),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.mediumPadding),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                              child: CachedNetworkImage(
                                imageUrl: item.menuItem.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.mediumPadding),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.menuItem.name,
                                    style: AppConstants.titleStyle.copyWith(fontSize: 16),
                                  ),
                                  if (item.customizationSummary.isNotEmpty)
                                    Text(
                                      item.customizationSummary,
                                      style: AppConstants.subtitleStyle.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  const SizedBox(height: AppConstants.smallPadding),
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(2)}',
                                    style: AppConstants.priceStyle,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cart.updateQuantity(index, item.quantity - 1);
                                      },
                                      icon: const Icon(Icons.remove),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.grey[200],
                                        minimumSize: const Size(32, 32),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.smallPadding,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cart.updateQuantity(index, item.quantity + 1);
                                      },
                                      icon: const Icon(Icons.add),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppConstants.primaryColor,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(32, 32),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.removeItem(index);
                                  },
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildBottomSection(context, cart),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildBottomSection(BuildContext context, CartController cart) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${cart.itemCount} items)',
                  style: AppConstants.titleStyle.copyWith(fontSize: 18),
                ),
                Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: AppConstants.priceStyle.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _proceedToPayment(context, cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _proceedToPayment(BuildContext context, CartController cart) {
    final orderId = context.read<OrderController>().placeOrder(
      cart.items,
      cart.totalAmount,
    );
    
    cart.clearCart();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Placed Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: AppConstants.mediumPadding),
              Text('Order ID: $orderId'),
              const SizedBox(height: AppConstants.smallPadding),
              const Text('Your order has been placed and is being prepared.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const OrderTrackingScreen(),
                  ),
                );
              },
              child: const Text('Track Order'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }
}