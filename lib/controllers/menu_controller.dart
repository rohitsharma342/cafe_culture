import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class MenuController extends ChangeNotifier {
  List<MenuItem> _allItems = [];
  List<MenuItem> _filteredItems = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  
  List<MenuItem> get filteredItems => _filteredItems;
  List<String> get categories => ['All', ...{..._allItems.map((item) => item.category)}];
  String get selectedCategory => _selectedCategory;
  
  MenuController() {
    _loadMenuItems();
  }
  
  void _loadMenuItems() {
    _allItems = [
      MenuItem(
        id: '1',
        name: 'Espresso',
        description: 'Rich and bold espresso shot',
        price: 2.99,
        imageUrl: 'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400',
        category: 'Coffee',
        customizations: [
          Customization(
            name: 'Size',
            options: [
              CustomizationOption(name: 'Single', additionalPrice: 0.0),
              CustomizationOption(name: 'Double', additionalPrice: 1.5),
            ],
          ),
        ],
      ),
      MenuItem(
        id: '2',
        name: 'Cappuccino',
        description: 'Espresso with steamed milk and foam',
        price: 4.99,
        imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
        category: 'Coffee',
        customizations: [
          Customization(
            name: 'Size',
            options: [
              CustomizationOption(name: 'Small', additionalPrice: 0.0),
              CustomizationOption(name: 'Medium', additionalPrice: 1.0),
              CustomizationOption(name: 'Large', additionalPrice: 2.0),
            ],
          ),
          Customization(
            name: 'Milk Type',
            options: [
              CustomizationOption(name: 'Regular', additionalPrice: 0.0),
              CustomizationOption(name: 'Oat Milk', additionalPrice: 0.5),
              CustomizationOption(name: 'Almond Milk', additionalPrice: 0.5),
            ],
          ),
        ],
      ),
      MenuItem(
        id: '3',
        name: 'Croissant',
        description: 'Buttery, flaky French pastry',
        price: 3.50,
        imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
        category: 'Pastries',
        customizations: [
          Customization(
            name: 'Filling',
            options: [
              CustomizationOption(name: 'Plain', additionalPrice: 0.0),
              CustomizationOption(name: 'Chocolate', additionalPrice: 0.75),
              CustomizationOption(name: 'Almond', additionalPrice: 0.75),
            ],
          ),
        ],
      ),
      MenuItem(
        id: '4',
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with caesar dressing',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        category: 'Salads',
        customizations: [
          Customization(
            name: 'Add Protein',
            options: [
              CustomizationOption(name: 'None', additionalPrice: 0.0),
              CustomizationOption(name: 'Chicken', additionalPrice: 3.0),
              CustomizationOption(name: 'Shrimp', additionalPrice: 4.0),
            ],
          ),
        ],
      ),
      MenuItem(
        id: '5',
        name: 'Avocado Toast',
        description: 'Sourdough bread with fresh avocado',
        price: 7.50,
        imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400',
        category: 'Breakfast',
        customizations: [
          Customization(
            name: 'Add-ons',
            options: [
              CustomizationOption(name: 'None', additionalPrice: 0.0),
              CustomizationOption(name: 'Poached Egg', additionalPrice: 2.0),
              CustomizationOption(name: 'Feta Cheese', additionalPrice: 1.5),
            ],
          ),
        ],
      ),
      MenuItem(
        id: '6',
        name: 'Green Tea',
        description: 'Premium organic green tea',
        price: 3.25,
        imageUrl: 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400',
        category: 'Tea',
      ),
    ];
    _filteredItems = List.from(_allItems);
    notifyListeners();
  }
  
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }
  
  void searchItems(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }
  
  void _applyFilters() {
    _filteredItems = _allItems.where((item) {
      final categoryMatch = _selectedCategory == 'All' || item.category == _selectedCategory;
      final searchMatch = _searchQuery.isEmpty || 
          item.name.toLowerCase().contains(_searchQuery) ||
          item.description.toLowerCase().contains(_searchQuery);
      return categoryMatch && searchMatch;
    }).toList();
    notifyListeners();
  }
  
  MenuItem? getItemById(String id) {
    try {
      return _allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}