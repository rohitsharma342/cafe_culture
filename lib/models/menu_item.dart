class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<Customization> customizations;
  
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.customizations = const [],
  });
}

class Customization {
  final String name;
  final List<CustomizationOption> options;
  final bool isRequired;
  
  Customization({
    required this.name,
    required this.options,
    this.isRequired = false,
  });
}

class CustomizationOption {
  final String name;
  final double additionalPrice;
  
  CustomizationOption({
    required this.name,
    required this.additionalPrice,
  });
}