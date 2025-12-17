class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> sizes;
  final List<String> extras;
  final bool isAvailable;
  final double rating;
  final int reviewCount;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.sizes = const [],
    this.extras = const [],
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      sizes: List<String>.from(json['sizes'] ?? []),
      extras: List<String>.from(json['extras'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'sizes': sizes,
      'extras': extras,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}