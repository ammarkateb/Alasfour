import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../widgets/shared_nav.dart';
import '../controllers/products_controller.dart';
import '../models/product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductsController(),
      child: Consumer<ProductsController>(
        builder: (context, controller, _) {
          final topPadding = MediaQuery.of(context).padding.top;

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (controller.error != null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'خطأ في تحميل المنتجات',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error!,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.refreshProducts(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                else
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 220, bottom: 80),
                    child: _buildProductsContent(controller),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildCustomHeader(context, topPadding, controller),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildSharedBottomNav(context),
                ),
                // Floating gold home button
                buildFloatingHomeButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // Custom header with search bar in red area
  Widget _buildCustomHeader(BuildContext context, double topPadding, ProductsController controller) {
    return Builder(
      builder: (context) => SizedBox(
        height: 400,
        child: Stack(
          children: [
            // Red background with curve
            ClipPath(
              clipper: HeaderCurveClipper(),
              child: Container(
                height: 335,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFC81419),  // Upper-middle
                      Color(0xFFD41419),  // Middle
                      Color(0xFFDF1619),  // Lower-middle
                      Color(0xFFE31719),  // Bottom
                      Color(0xFFE91A19),  // Bottom-most
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Header content
            Padding(
              padding: EdgeInsets.only(top: kIsWeb ? topPadding + 8 : 8),
              child: Column(
                children: [
                  // Top row: notification, logo, avatar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNotificationBell(context),
                        _buildCenterLogo(),
                        _buildProfileAvatar(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 37), // Set to 37 to raise search bar
                  // SEARCH BAR in red area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSearchBar(controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notification bell widget
  Widget _buildNotificationBell(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('Design materials/Icons/Frame.svg', fit: BoxFit.contain),
      ),
    );
  }

  // Center logo widget
  Widget _buildCenterLogo() {
    return SizedBox(
      height: 87,
      width: 104,
      child: Image.asset('assets/images/high ress logo.png', fit: BoxFit.contain),
    );
  }

  // Profile avatar widget
  Widget _buildProfileAvatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 52),
      child: Container(
        width: 37,
        height: 37,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsContent(ProductsController controller) {
    return Column(
      children: [
        // "أحدث المنتجات" text at start of white background
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(22.5, 25, 22.5, 0), // Increased from 20 to 25 to lower title
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'أحدث المنتجات',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.w500, // Changed from bold to medium
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1), // Light shadow
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // PRODUCT CARDS (dynamic from controller)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(22.5, 52, 22.5, 16), // Lowered by 12px (~5%)
          child: _buildProductCards(controller),
        ),
      ],
    );
  }

  // Search bar with filter - exact copy from final screen
  Widget _buildSearchBar(ProductsController controller) {
    return Row(
      children: [
        // Filter button with Group 5 icon (gold gradient like search bar)
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(17)),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFFEFCB45), // brighter gold at sides
                Color(0xFFC9941A), // darkest gold band
                Color(0xFFEFCB45), // brighter gold at sides
              ],
              stops: [0.0, 0.3, 1.0], // dark band shifted a bit toward the right
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000), // soft shadow under button
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'Design materials/Icons/Group 5.svg',
              width: 17,
              height: 17,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Search field with gold gradient border (darker center, lighter sides)
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFE5B52F), // darker gold at sides
                  Color(0xFFC9941A), // darkest gold in center
                  Color(0xFFE5B52F), // darker gold at sides
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000), // soft shadow under bar
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(1), // thickness of the gold border
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.right,
                      onChanged: controller.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن منتج',
                        hintStyle: TextStyle(fontFamily: 'Tajawal', color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Increased from 14 to 20 to raise text
                        suffixIcon: Transform.scale(
                          scale: 0.47,
                          child: SvgPicture.asset(
                            'Design materials/Icons/Search_Magnifying_Glass.svg',
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCards(ProductsController controller) {
    final products = controller.products;
    
    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2) ...[
          if (i + 1 < products.length)
            _buildProductRow(
              products[i],
              products[i + 1],
              controller,
            )
          else
            Row(
              children: [
                Expanded(child: _buildProductCard(products[i], controller)),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()), // Empty space for alignment
              ],
            ),
          if (i + 2 < products.length) const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildProductRow(
      Product product1,
      Product product2,
      ProductsController controller) {
    return Row(
      children: [
        Expanded(child: _buildProductCard(product1, controller)),
        const SizedBox(width: 12),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -17), // Move right card up by 17 pixels
            child: _buildProductCard(product2, controller),
          ),
        ),
      ],
    );
  }

  // New product card design from final screen - photo only
  Widget _buildProductCard(Product product, ProductsController controller) {
    return Stack(
      clipBehavior: Clip.none, // Allow children to extend outside Stack bounds
      children: [
        // Main card content with AnimatedButton
        AnimatedButton(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Product card with photo only - exact design from final screen
              Container(
                width: 160, // Increased from 142 to make cards wider
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    product.imagePath,
                    height: 175, // Same height as final screen
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Text displayed separately underneath
              Text(
                product.title,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Same font size as final screen
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              if (product.subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.subtitle,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ),
        // Favorite button floating above everything, centered on top-left card corner
        Positioned(
          top: -7, // Only 1/4 of circle (7px) shows above top edge
          left: 0, // Left edge of circle aligned with left edge of card
          child: GestureDetector(
            onTap: () => controller.toggleFavorite(product.id),
            child: Container(
              width: 28, // Same size as final screen
              height: 28,
              decoration: BoxDecoration(
                color: product.isFavorite ? Color(0xFFFFE4E1) : Color(0xFFE9ECEF), // Change color when favorited
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1), // Thin white border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'Design materials/Icons/Frame 2147227093.svg', // Same heart icon
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  product.isFavorite ? Colors.red : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
