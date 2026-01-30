import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'product_image.dart';
import 'price_tag.dart';
import 'favorite_button.dart';
import 'add_to_cart_button.dart';
import 'stock_indicator.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductService(),
      child: Consumer<ProductService>(
        builder: (context, productService, _) {
          final isFavorite = productService.getProductById(product.id)?.isFavorite ?? false;

          return GestureDetector(
            onTap: () {
              // Navigate to product details with product as argument
              Navigator.pushNamed(context, '/product-details', arguments: product);
            },
            child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with favorite button
                Stack(
                  children: [
                    ProductImage(
                      imagePath: product.imagePath,
                      height: 120,
                      width: double.infinity,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavoriteButton(
                        product: product,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                    // Alasfour logo
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'Design materials/images/high ress logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Product Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Price and stock info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceTag(
                              price: product.price,
                              currency: 'KD',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            StockIndicator(
                              product: product,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                        if (product.stockQuantity < 10 && product.isAvailable)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'متبقي: ${product.stockQuantity}',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.orange[700],
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}
