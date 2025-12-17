import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafe_culture/models/menu_item.dart';
import 'package:cafe_culture/controllers/cart_controller.dart';
import 'package:cafe_culture/utils/constants.dart';

class OrderDetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  const OrderDetailScreen({Key? key, required this.menuItem}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final CartController cartController = Get.find();
  
  int quantity = 1;
  String selectedSize = '';
  List<String> selectedExtras = [];
  
  double get basePrice => widget.menuItem.price;
  double get sizePrice {
    if (selectedSize == 'Large') return 0.50;
    if (selectedSize == 'Medium') return 0.25;
    return 0.0;
  }
  double get extrasPrice => selectedExtras.length * 0.50;
  double get totalPrice => (basePrice + sizePrice + extrasPrice) * quantity;

  @override
  void initState() {
    super.initState();
    if (widget.menuItem.sizes.isNotEmpty) {
      selectedSize = widget.menuItem.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.menuItem.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.menuItem.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '\$${basePrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        if (widget.menuItem.sizes.isNotEmpty) ...[
                          Text(
                            'Size',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.menuItem.sizes.map((size) {
                              return ChoiceChip(
                                label: Text(size),
                                selected: selectedSize == size,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                  }
                                },
                                selectedColor: AppConstants.primaryColor.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: selectedSize == size
                                      ? AppConstants.primaryColor
                                      : AppConstants.textSecondary,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 24),
                        ],
                        if (widget.menuItem.extras.isNotEmpty) ...[
                          Text(
                            'Extras (+\$0.50 each)',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.menuItem.extras.map((extra) {
                              return FilterChip(
                                label: Text(extra),
                                selected: selectedExtras.contains(extra),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedExtras.add(extra);
                                    } else {
                                      selectedExtras.remove(extra);
                                    }
                                  });
                                },
                                selectedColor: AppConstants.primaryColor.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: selectedExtras.contains(extra)
                                      ? AppConstants.primaryColor
                                      : AppConstants.textSecondary,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 24),
                        ],
                        Text(
                          'Quantity',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1
                                  ? () {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  : null,
                              icon: Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: AppConstants.textPrimary,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                quantity.toString(),
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                                foregroundColor: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartController.addToCart(
                        menuItem: widget.menuItem,
                        quantity: quantity,
                        selectedSize: selectedSize,
                        selectedExtras: selectedExtras,
                      );
                      Get.back();
                    },
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}