import 'package:flutter/material.dart';
import '../models/product.dart';

class StockIndicator extends StatelessWidget {
  final Product product;
  final TextStyle? style;
  final IconData? icon;
  final bool showText;

  const StockIndicator({
    super.key,
    required this.product,
    this.style,
    this.icon,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final available = product.isAvailable && product.stockQuantity > 0;
    final stockColor = available ? Colors.green : Colors.red;
    final stockIcon = icon ?? (available ? Icons.check_circle : Icons.error);
    final stockText = available 
        ? 'متوفر (${product.stockQuantity})'
        : 'غير متوفر';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          stockIcon,
          color: stockColor,
          size: 16,
        ),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            stockText,
            style: style ?? TextStyle(
              fontSize: 12,
              color: stockColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ],
    );
  }
}
