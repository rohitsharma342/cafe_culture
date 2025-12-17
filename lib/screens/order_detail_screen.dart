import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../controllers/cart_controller.dart';
import '../models/menu_item.dart';

class OrderDetailScreen extends StatefulWidget {
  final MenuItem menuItem;
  
  const OrderDetailScreen({super.key, required this.menuItem});
  
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int quantity = 1;
  final Map<String, CustomizationOption> selectedCustomizations = {};
  
  @override
  void initState() {
    super.initState();
    for (var customization in widget.menuItem.customizations) {
      if (customization.options.isNotEmpty) {
        selectedCustomizations[customization.name] = customization.options.first;
      }
    }
  }
  
  double get totalPrice {
    double customizationPrice = selectedCustomizations.values
        .fold(0.0, (sum, option) => sum + option.additionalPrice);
    return (widget.menuItem.price + customizationPrice) * quantity;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    child: CachedNetworkImage(
                      imageUrl: widget.menuItem.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    widget.menuItem.name,
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    widget.menuItem.description,
                    style: AppConstants.subtitleStyle,
                  ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    '\$${widget.menuItem.price.toStringAsFixed(2)}',
                    style: AppConstants.priceStyle,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  
                  ...widget.menuItem.customizations.map((customization) =>
                    _buildCustomizationSection(customization)
                  ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  _buildQuantitySelector(),
                ],
              ),
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }
  
  Widget _buildCustomizationSection(Customization customization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          customization.name,
          style: AppConstants.titleStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        ...customization.options.map((option) =>
          RadioListTile<CustomizationOption>(
            title: Text(option.name),
            subtitle: option.additionalPrice > 0
                ? Text('+\$${option.additionalPrice.toStringAsFixed(2)}')
                : null,
            value: option,
            groupValue: selectedCustomizations[customization.name],
            onChanged: (CustomizationOption? value) {
              if (value != null) {
                setState(() {
                  selectedCustomizations[customization.name] = value;
                });
              }
            },
            activeColor: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(height: AppConstants.mediumPadding),
      ],
    );
  }
  
  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity',
          style: AppConstants.titleStyle.copyWith(fontSize: 18),
        ),
        const Spacer(),
        IconButton(
          onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: AppConstants.textColor,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
          child: Text(
            '$quantity',
            style: AppConstants.titleStyle.copyWith(fontSize: 18),
          ),
        ),
        IconButton(
          onPressed: () => setState(() => quantity++),
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomSection() {
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
                  'Total',
                  style: AppConstants.titleStyle.copyWith(fontSize: 18),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: AppConstants.priceStyle.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _addToCart() {
    context.read<CartController>().addItem(
      widget.menuItem,
      quantity,
      selectedCustomizations,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.menuItem.name} added to cart'),
        backgroundColor: AppConstants.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
    
    Navigator.of(context).pop();
  }
}