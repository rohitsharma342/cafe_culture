import 'package:get/get.dart';
import 'package:cafe_culture/models/menu_item.dart';

class MenuController extends GetxController {
  final RxList<MenuItem> _menuItems = <MenuItem>[].obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  List<MenuItem> get menuItems => _menuItems;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoading => _isLoading.value;

  List<MenuItem> get filteredItems {
    List<MenuItem> filtered = _menuItems;

    if (_selectedCategory.value != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory.value).toList();
    }

    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
               item.description.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
               item.category.toLowerCase().contains(_searchQuery.value.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadMenuItems();
  }

  void loadMenuItems() {
    _isLoading.value = true;
    
    // Simulated menu data
    final List<MenuItem> sampleItems = [
      MenuItem(
        id: '1',
        name: 'Espresso',
        description: 'Rich and bold espresso shot',
        price: 2.50,
        imageUrl: 'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400',
        category: 'Coffee',
        sizes: ['Small', 'Medium', 'Large'],
        extras: ['Extra Shot', 'Decaf', 'Sugar'],
        rating: 4.5,
        reviewCount: 128,
      ),
      MenuItem(
        id: '2',
        name: 'Cappuccino',
        description: 'Creamy cappuccino with perfect foam',
        price: 3.75,
        imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
        category: 'Coffee',
        sizes: ['Small', 'Medium', 'Large'],
        extras: ['Extra Shot', 'Oat Milk', 'Vanilla Syrup'],
        rating: 4.7,
        reviewCount: 95,
      ),
      MenuItem(
        id: '3',
        name: 'Green Tea Latte',
        description: 'Smooth green tea with steamed milk',
        price: 4.25,
        imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
        category: 'Tea',
        sizes: ['Small', 'Medium', 'Large'],
        extras: ['Honey', 'Almond Milk', 'Extra Matcha'],
        rating: 4.3,
        reviewCount: 67,
      ),
      MenuItem(
        id: '4',
        name: 'Croissant',
        description: 'Buttery, flaky French croissant',
        price: 2.95,
        imageUrl: 'https://images.unsplash.com/photo-1555507036-ab794f4ade2a?w=400',
        category: 'Pastries',
        extras: ['Butter', 'Jam', 'Honey'],
        rating: 4.6,
        reviewCount: 84,
      ),
      MenuItem(
        id: '5',
        name: 'Club Sandwich',
        description: 'Triple-decker sandwich with turkey and bacon',
        price: 8.50,
        imageUrl: 'https://images.unsplash.com/photo-1553909489-cd47e0ef937f?w=400',
        category: 'Sandwiches',
        extras: ['Extra Bacon', 'Avocado', 'Cheese'],
        rating: 4.4,
        reviewCount: 112,
      ),
      MenuItem(
        id: '6',
        name: 'Chocolate Cake',
        description: 'Rich chocolate cake with ganache',
        price: 4.75,
        imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
        category: 'Desserts',
        extras: ['Ice Cream', 'Whipped Cream', 'Berries'],
        rating: 4.8,
        reviewCount: 156,
      ),
    ];

    Future.delayed(Duration(milliseconds: 500), () {
      _menuItems.assignAll(sampleItems);
      _isLoading.value = false;
    });
  }

  void updateCategory(String category) {
    _selectedCategory.value = category;
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  MenuItem? getMenuItem(String id) {
    try {
      return _menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MenuItem> getItemsByCategory(String category) {
    if (category == 'All') return _menuItems;
    return _menuItems.where((item) => item.category == category).toList();
  }

  void refreshMenu() {
    loadMenuItems();
  }
}