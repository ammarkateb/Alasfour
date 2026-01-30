import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  final String? text;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final bool navigateToCart;

  const AddToCartButton({
    super.key,
    required this.product,
    this.text,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.navigateToCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductService(),
      child: Consumer<ProductService>(
        builder: (context, productService, _) {
          final isInCart = productService.cartItems.any((item) => item.product.id == product.id);
          final available = product.isAvailable && product.stockQuantity > 0;

          return SizedBox(
            width: width,
            height: height ?? 45,
            child: ElevatedButton.icon(
              onPressed: available && !isInCart 
                  ? () {
                    productService.addToCart(product.id);
                    (onPressed ?? () {})();
                    if (navigateToCart) {
                      Navigator.pushNamed(context, '/cart');
                    }
                  }
                  : null,
              icon: Icon(
                isInCart ? Icons.check : Icons.shopping_cart,
                color: textColor ?? Colors.white,
                size: 20,
              ),
              label: Text(
                isInCart 
                    ? (text ?? 'في السلة')
                    : available 
                        ? (text ?? 'إضافة للسلة')
                        : (text ?? 'غير متوفر'),
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: available 
                    ? (backgroundColor ?? const Color(0xFFD3AF37))
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
