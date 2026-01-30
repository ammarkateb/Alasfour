import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CircleArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE5CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // TOP ARC
    final topRect = Rect.fromCircle(
      center: Offset(size.width * 0.52, size.height * 0.024),
      radius: size.width * 0.584,
    );
    canvas.drawArc(
      topRect,
      3.0,
      -2.5,
      false,
      paint,
    );

    // BOTTOM ARC
    final bottomRect = Rect.fromCircle(
      center: Offset(size.width * 0.85, size.height * 1.05),
      radius: size.width * 0.97,
    );
    canvas.drawArc(
      bottomRect,
      3.14,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
