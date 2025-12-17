import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final Map<String, CustomizationOption> selectedCustomizations;
  
  CartItem({
    required this.menuItem,
    required this.quantity,
    required this.selectedCustomizations,
  });
  
  double get totalPrice {
    double customizationPrice = selectedCustomizations.values
        .fold(0.0, (sum, option) => sum + option.additionalPrice);
    return (menuItem.price + customizationPrice) * quantity;
  }
  
  String get customizationSummary {
    if (selectedCustomizations.isEmpty) return '';
    return selectedCustomizations.values
        .map((option) => option.name)
        .join(', ');
  }
}