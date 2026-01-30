import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw scanning frame
    final frameSize = size.width * 0.7;
    final frameOffset = (size.width - frameSize) / 2;
    
    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(frameOffset, frameOffset + 40)
        ..lineTo(frameOffset, frameOffset)
        ..lineTo(frameOffset + 40, frameOffset),
      paint,
    );
    
    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - frameOffset - 40, frameOffset)
        ..lineTo(size.width - frameOffset, frameOffset)
        ..lineTo(size.width - frameOffset, frameOffset + 40),
      paint,
    );
    
    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(frameOffset, size.height - frameOffset - 40)
        ..lineTo(frameOffset, size.height - frameOffset)
        ..lineTo(frameOffset + 40, size.height - frameOffset),
      paint,
    );
    
    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - frameOffset - 40, size.height - frameOffset)
        ..lineTo(size.width - frameOffset, size.height - frameOffset)
        ..lineTo(size.width - frameOffset, size.height - frameOffset - 40),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
