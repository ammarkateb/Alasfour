import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IntroScreenController(),
      child: Consumer<IntroScreenController>(
        builder: (context, controller, _) {
          final size = MediaQuery.of(context).size;

          // RED COLORS (from mockup)
          const List<Color> finalRed = [
            Color(0xFFE31118),
            Color(0xFFDC1419),
            Color(0xFFD41318),
          ];

          // SEPARATE REDS FOR CONTRAST
          const List<Color> rightRed = [
            Color(0xFFE31118), // Bright center (now at bottom right)
            Color(0xFFE31118), // Bright - extend length
            Color(0xFFE31118), // Bright - extend more
            Color(0xFFD41318), // Lighter
            Color(0xFFC21617), // Medium
            Color(0xFFB11C20), // Dark edges (now at top right)
          ];

          const List<Color> leftRed = [
            Color(0xFFE31118), // Bright red (switched)
            Color(0xFFE51118),
            Color(0xFFE81118),
          ];

          // BRIGHT RED FOR BOTTOM CIRCLE
          const List<Color> bottomRed = [
            Color(0xFFDA1318), // More noticeably brighter
            Color(0xFFD61318),
            Color(0xFFD21318),
          ];

          // YELLOW (from mockup - using lighter colors only)
          const List<Color> finalYellow = [
            Color(0xFFFFD54F),
            Color(0xFFFFD54F),
            Color(0xFFFFD54F),
          ];

          return Scaffold(
            body: Stack(
              children: [
                // 1. BASE YELLOW GRADIENT
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: finalYellow,
                    ),
                  ),
                ),

                // 2. TOP LEFT CURVED SHAPE
                Positioned.fill(
                  child: CustomPaint(
                    painter: TopLeftCurvePainter(leftRed),
                  ),
                ),

                // 3. TOP RIGHT CURVED SHAPE
                Positioned.fill(
                  child: CustomPaint(
                    painter: TopRightCurvePainter(rightRed),
                  ),
                ),

                // 4. BOTTOM RED CIRCLE
                Positioned(
                  bottom: -size.height * 0.32,
                  left: -size.width * 0.21,
                  right: -size.width * 0.14,
                  child: Container(
                    width: size.width * 1.50,
                    height: size.width * 1.50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: bottomRed,
                      ),
                    ),
                  ),
                ),

                // 5. WHITE CIRCULAR LINES (TOP & BOTTOM)
                Positioned.fill(
                  child: CustomPaint(
                    painter: CircleArcPainter(),
                  ),
                ),

                // 6. LOGO AT TOP
                Positioned(
                  top: size.height * 0.038,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 132,
                      height: 99,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/high ress logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // 7. PRODUCT CARDS
                _buildProductTabs(size),

                // 8. TEXT & ACTION OVERLAY
                _buildOverlay(size, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductTabs(Size size) {
    return Stack(
      children: [
        // LEFT CARD (behind, tilted)
        Positioned(
          top: size.height * 0.49,
          left: -size.width * 0.114,
          child: Transform.rotate(
            angle: -0.65,
            child: _productCard(
              width: size.width * 0.22,
              height: size.width * 0.27,
              redBarHeight: 14,  // Bigger red bar for side cards
              imagePath: 'assets/images/488908302_1123782413094973_3503546681784529641_n-removebg-preview.png',
            ),
          ),
        ),

        // RIGHT CARD (behind, tilted)
        Positioned(
          top: size.height * 0.28,
          right: -size.width * 0.114,
          child: Transform.rotate(
            angle: 0.089,
            child: _productCard(
              width: size.width * 0.32,
              height: size.width * 0.365,
              redBarHeight: 19,  // Bigger red bar for side cards
              imagePath: 'assets/images/489124110_1121945699945311_9214270868333967089_n.jpg',
              padding: 6,  // Right card 6px thickness
            ),
          ),
        ),

        // CENTER MAIN CARD (front, prominent) - LAST = ON TOP
        Positioned(
          top: size.height * 0.345,
          left: (size.width - size.width * 0.575) / 2,  // Center the card
          child: Container(
            width: size.width * 0.575,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),  // Medium shadow (halfway)
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Transform.rotate(
              angle: -0.235,  // Add rotation here
              child: _productCard(
                width: size.width * 0.575,
                height: size.width * 0.7,
                redBarHeight: 34,
                isMain: false,
                imagePath: 'assets/images/487958174_1121384120001469_697759111300351151_n.jpg',
                padding: 10,  // Center card 10px thickness
              ),
            ),
          ),
        ),
      ],
    );
  }

  // HELPER WIDGET FOR THE WHITE CARD
  Widget _productCard({
    required double width,
    required double height,
    required double redBarHeight,
    required String imagePath,
    bool isMain = false,
    double padding = 5,  // Default padding
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Color(0xFFD8D8D8), // Medium grey background color
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Product Area (Ready for images)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(5),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.contain,  // Shows full photo without cropping
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: isMain ? 12 : 8),
          // The Red Bar at the Bottom
          Container(
            height: redBarHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD30000),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(Size size, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 31, right: 31),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "من هنا تبدأ رحلتك مع منتجات العصفور.\u200F", 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: Color(0xFFFFFFFF), 
                fontSize: 23, 
                fontFamily: 'Tajawal',
                height: 1.27,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              "جودة نعرفها، ونشاركها معك بكل ثقة.\u200F", 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF), 
                fontSize: 19,
                fontFamily: 'Tajawal',
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(false), _dot(true), _dot(false),
              ],
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Container(
                height: 48, 
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1211), 
                  borderRadius: BorderRadius.circular(29)
                ),
                child: Center(
                  child: Text(
                    "ابدء الأن", 
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), 
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class IntroScreenController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  ProductService get productService => _productService;
  
  IntroScreenController() {
    _initializeProducts();
  }
  
  void _initializeProducts() {
    if (_productService.products.isEmpty) {
      _productService.loadProducts();
    }
  }
}

class CircleArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFFE5CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // TOP ARC – follows the overlapping top circles
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

    // BOTTOM ARC – follows the bottom circle
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

// --- CURVE PAINTER ---

class FinalStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(0, size.height * 0.18)
      ..cubicTo(size.width * 0.4, size.height * 0.22, size.width * 0.8, size.height * 0.35, size.width, size.height * 0.75);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(size.width * 0.3, size.height * 0.55, size.width * 0.7, size.height * 0.65, size.width, size.height * 0.9);
    canvas.drawPath(path2, paint);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}

// --- BOTTOM CLIPPER ---

class FinalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height * 0.38)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.05, size.width, size.height * 0.38)
      ..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
  }
  @override bool shouldReclip(CustomClipper<Path> old) => false;
}

// --- TOP RIGHT CURVE PAINTER ---
class TopRightCurvePainter extends CustomPainter {
  final List<Color> colors;
  
  TopRightCurvePainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    // Specs: Start (100%, 14%), Lowest (58%, 25%), End (2%, 0%)
    // Using cubic Bézier for wider, rounder curve
    
    final path = Path()
      ..moveTo(size.width, size.height * 0.14)  // Start: right edge, 14% from top
      ..cubicTo(
        size.width * 0.93, size.height * 0.28,   // Control 1: wider from right
        size.width * 0.20, size.height * 0.35,   // Control 2: rounder on left
        size.width * 0.02, 0,                     // End: 2% from left, 0% from top
      )
      ..lineTo(size.width, 0)                    // Line to top right corner
      ..close();                                  // Close the shape

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- TOP LEFT CURVE PAINTER ---
class TopLeftCurvePainter extends CustomPainter {
  final List<Color> colors;
  
  TopLeftCurvePainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    // Specs: 
    // Start: left edge, 32% from top
    // Lowest: 45% from left, 37% from top
    // Continues to: 14% from right (86% from left), 23% from top
    // Extends behind right circle
    
    final path = Path()
      ..moveTo(0, size.height * 0.318)           // Start: left edge, 32% from top
      ..cubicTo(
        size.width * 0.75, size.height * 0.525,  // Control 1: rounder (less wide, less deep)
        size.width * 1.11, size.height * 0.03,  // Control 2: pull up toward top right
        size.width * 0.99, 0,                    // End: 1% from right, top edge
      )
      ..lineTo(0, 0)                            // Line to top left corner
      ..close();                                 // Close the shape

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.5))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
