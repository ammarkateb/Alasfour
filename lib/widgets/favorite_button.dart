import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final Product product;
  final double? size;
  final Color? color;
  final VoidCallback? onPressed;

  const FavoriteButton({
    super.key,
    required this.product,
    this.size,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductService(),
      child: Consumer<ProductService>(
        builder: (context, productService, _) {
          final isFavorite = productService.getProductById(product.id)?.isFavorite ?? false;

          return IconButton(
            onPressed: onPressed ?? () {
              productService.toggleFavorite(product.id);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: color ?? Colors.red,
              size: size ?? 24,
            ),
          );
        },
      ),
    );
  }
}
