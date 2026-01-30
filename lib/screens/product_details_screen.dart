import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/products_controller.dart';
import '../models/product.dart';
import '../widgets/shared_nav.dart';
import '../widgets/product_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/favorite_button.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/stock_indicator.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductsController(),
      child: Consumer<ProductsController>(
        builder: (context, controller, _) {
          // Get product from controller or navigation arguments
          Product? product = controller.selectedProduct;
          
          if (product == null) {
            // Try to get from navigation arguments
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Product) {
              product = args;
            } else {
              // No product found, show error
            return Scaffold(
              appBar: AppBar(
                title: const Text('تفاصيل المنتج'),
                backgroundColor: const Color(0xFFD30000),
              ),
              body: const Center(
                child: Text(
                  'المنتج غير موجود',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            );
          }
        }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 100, bottom: 120),
                  child: Column(
                    children: [
                      _buildProductImage(product),
                      _buildProductInfo(product),
                      _buildProductActions(product, controller),
                    ],
                  ),
                ),
                // Fixed header
                _buildFixedHeader(context, product),
                // Bottom navigation
                buildSharedBottomNav(context),
                // Floating home button
                buildFloatingHomeButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context, Product product) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFFD30000),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // Product name
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return ProductImage(
      imagePath: product.imagePath,
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(15),
      fit: BoxFit.contain,
    );
  }

  Widget _buildProductInfo(Product product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceTag(
                price: product.price,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              Expanded(
                child: Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Category
          Text(
            product.category,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Tajawal',
              height: 1.5,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          
          // Stock status
          StockIndicator(
            product: product,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductActions(Product product, ProductsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Favorite button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.toggleFavorite(product.id);
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                product.isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD30000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Add to cart button
          AddToCartButton(
            product: product,
            text: product.isAvailable ? 'إضافة إلى السلة' : 'غير متوفر',
            height: 50,
            navigateToCart: true,
            onPressed: product.isAvailable ? () {
              controller.addToCart(product.id);
            } : null,
          ),
        ],
      ),
    );
  }
}
