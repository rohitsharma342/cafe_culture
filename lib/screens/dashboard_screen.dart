import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../controllers/cart_controller.dart';
import '../controllers/menu_controller.dart' as menu;
import '../widgets/menu_item_card.dart';
import '../widgets/category_tab.dart';
import 'cart_screen.dart';
import 'order_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: AppConstants.titleStyle.copyWith(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
              );
            },
          ),
          Consumer<CartController>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (query) {
                context.read<menu.MenuController>().searchItems(query);
              },
            ),
          ),
          Consumer<menu.MenuController>(
            builder: (context, menuController, child) {
              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuController.categories.length,
                  itemBuilder: (context, index) {
                    final category = menuController.categories[index];
                    return CategoryTab(
                      category: category,
                      isSelected: category == menuController.selectedCategory,
                      onTap: () => menuController.filterByCategory(category),
                    );
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<menu.MenuController>(
              builder: (context, menuController, child) {
                if (menuController.filteredItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'No items found',
                      style: AppConstants.subtitleStyle,
                    ),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.mediumPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppConstants.mediumPadding,
                    mainAxisSpacing: AppConstants.mediumPadding,
                  ),
                  itemCount: menuController.filteredItems.length,
                  itemBuilder: (context, index) {
                    return MenuItemCard(
                      menuItem: menuController.filteredItems[index],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            child: Text(
              '© 2024 ${AppConstants.appName}. All rights reserved.',
              style: AppConstants.subtitleStyle.copyWith(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}