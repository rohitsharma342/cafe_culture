import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_culture/controllers/menu_controller.dart' as menu;
import 'package:cafe_culture/controllers/cart_controller.dart';
import 'package:cafe_culture/utils/constants.dart';
import 'package:cafe_culture/widgets/menu_item_card.dart';
import 'package:cafe_culture/widgets/category_tab.dart';
import 'package:cafe_culture/screens/cart_screen.dart';
import 'package:cafe_culture/screens/order_tracking_screen.dart';

class DashboardScreen extends StatelessWidget {
  final menu.MenuController menuController = Get.find();
  final CartController cartController = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'No new notifications',
                duration: Duration(seconds: 2),
              );
            },
          ),
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Get.to(() => CartScreen()),
                  ),
                  if (cartController.cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartController.cartCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              menuController.updateSearchQuery('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    menuController.updateSearchQuery(value);
                  },
                ),
                SizedBox(height: 16),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppConstants.categories.length,
                    itemBuilder: (context, index) {
                      final category = AppConstants.categories[index];
                      return Obx(() => CategoryTab(
                            category: category,
                            isSelected: menuController.selectedCategory == category,
                            onTap: () => menuController.updateCategory(category),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (menuController.filteredItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No items found',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filter',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: menuController.filteredItems.length,
                itemBuilder: (context, index) {
                  return MenuItemCard(
                    menuItem: menuController.filteredItems[index],
                  );
                },
              );
            }),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(() => OrderTrackingScreen()),
                    icon: Icon(Icons.track_changes),
                    label: Text('Track Orders'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: AppConstants.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                        onPressed: cartController.isEmpty
                            ? null
                            : () => Get.to(() => CartScreen()),
                        icon: Icon(Icons.shopping_cart),
                        label: Text(
                          'Cart (${cartController.cartCount})',
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 8,
            ),
            child: Text(
              '© 2024 ${AppConstants.tagline}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}