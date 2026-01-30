import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/shared_nav.dart';
import '../widgets/product_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/stock_indicator.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartController(),
      child: Consumer<CartController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 100, bottom: 120),
                  child: Column(
                    children: [
                      if (controller.isEmpty)
                        _buildEmptyCart(context)
                      else
                        _buildCartContent(context, controller),
                    ],
                  ),
                ),
                // Fixed header
                _buildFixedHeader(context, controller),
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

  Widget _buildFixedHeader(BuildContext context, CartController controller) {
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
          // Cart title and count
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'السلة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.itemCount} منتججات',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Clear cart button
          if (!controller.isEmpty)
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                onPressed: () => _showClearCartDialog(context, controller),
                icon: const Icon(Icons.delete_outline, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'السلة فارغة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف بعض المنتجات لتبدأ التسوق',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD30000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'تسوق الآن',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Tajawal',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartController controller) {
    return Column(
      children: [
        // Cart items list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.cartItems.length,
          itemBuilder: (context, index) {
            final item = controller.cartItems[index];
            return _buildCartItem(context, controller, item, index);
          },
        ),
        const SizedBox(height: 20),
        // Cart summary
        _buildCartSummary(context, controller),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartController controller, CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.all(8),
            child: ProductImage(
              imagePath: item.product.imagePath,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Product details and controls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  PriceTag(
                    price: item.product.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  StockIndicator(
                    product: item.product,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Quantity controls
          Column(
            children: [
              // Remove button
              IconButton(
                onPressed: () => controller.removeFromCart(item.product.id),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
              const SizedBox(height: 8),
              // Quantity controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => controller.decrementQuantity(item.product.id),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.incrementQuantity(item.product.id),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الفرعي:',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                '\$${controller.getSubtotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tax (example 10%)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ضريبة القيمة المضافة (10%):',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                '\$${controller.getTax(0.1).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الكلي:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                '\$${controller.getTotalWithTax(0.1).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD30000),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading 
                  ? null 
                  : () => _showCheckoutDialog(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD30000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: controller.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    'إتمام الطلب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تفريغ السلة',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text(
          'هل أنت متأكد من أنك تريد تفريغ السلة؟',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.clearCart();
            },
            child: const Text(
              'تفريغ',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Color(0xFFD30000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تأكيد الطلب',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Text(
          'المجموع الكلي: \$${controller.getTotalWithTax(0.1).toStringAsFixed(2)}\n\nهل تريد تأكيد الطلب؟',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.processCheckout();
              if (success) {
                _showOrderSuccessDialog(context);
              } else {
                _showOrderErrorDialog(context, controller.error);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD30000),
            ),
            child: const Text(
              'تأكيد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تم بنجاح!',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text(
          'تم تقديم طلبك بنجاح.\nشكرا لتسوقك معنا!',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD30000),
            ),
            child: const Text(
              'حسنا',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderErrorDialog(BuildContext context, String? error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'فشل الطلب',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Text(
          error ?? 'حدث خطأأ ما أثناء معالجة طلبك.',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسنا',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }
}
