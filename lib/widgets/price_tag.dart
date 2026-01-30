import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final TextStyle? style;
  final String? currency;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const PriceTag({
    super.key,
    required this.price,
    this.style,
    this.currency = '\$',
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currency${price.toStringAsFixed(2)}',
      style: style ?? const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFFD30000),
        fontFamily: 'Tajawal',
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
