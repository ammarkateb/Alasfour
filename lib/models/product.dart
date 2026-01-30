import 'package:flutter/foundation.dart';

// Central Product Model - used across entire app
class Product {
  final String id;
  final String name;
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final double price;
  final String category;
  final int stockQuantity;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    this.stockQuantity = 0,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  // Factory constructor for creating from API response
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  // Copy with updates
  Product copyWith({
    String? id,
    String? name,
    String? title,
    String? subtitle,
    String? description,
    String? imagePath,
    double? price,
    String? category,
    int? stockQuantity,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}

// Product categories
enum ProductCategory {
  all('الكل'),
  legumes('بقوليات'),
  beverages('مشروبات'),
  sweets('حلويات'),
  dates('تمور'),
  rice('أرز');

  const ProductCategory(this.displayName);
  final String displayName;
}

// Product filter options
class ProductFilter {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final bool? onlyAvailable;
  final bool? onlyFavorites;

  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.onlyAvailable,
    this.onlyFavorites,
  });

  ProductFilter copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? onlyAvailable,
    bool? onlyFavorites,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

// Shopping cart item
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
