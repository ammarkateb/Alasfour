import 'package:flutter/foundation.dart';
import '../services/product_service.dart';
import '../models/product.dart';

// Dedicated Cart Controller for Step 5
class CartController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  // UI-specific cart state
  bool _isLoading = false;
  String? _error;
  bool _isCheckoutMode = false;

  // Public getters
  List<CartItem> get cartItems => _productService.cartItems;
  double get totalPrice => _productService.cartTotalPrice;
  int get itemCount => _productService.cartItemCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCheckoutMode => _isCheckoutMode;
  bool get isEmpty => cartItems.isEmpty;

  // Constructor
  CartController() {
    _productService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  // Cart operations
  void removeFromCart(String productId) {
    try {
      _setLoading(true);
      _productService.removeFromCart(productId);
      _clearError();
    } catch (e) {
      _setError('Failed to remove item from cart: $e');
    } finally {
      _setLoading(false);
    }
  }

  void updateQuantity(String productId, int quantity) {
    try {
      _setLoading(true);
      if (quantity <= 0) {
        _productService.removeFromCart(productId);
      } else {
        final item = _productService.cartItems.firstWhere(
          (item) => item.product.id == productId,
          orElse: () => CartItem(product: _productService.getProductById(productId)!, quantity: 0),
        );
        // Update quantity by removing and re-adding
        _productService.removeFromCart(productId);
        _productService.addToCart(productId, quantity: quantity);
      }
      _clearError();
    } catch (e) {
      _setError('Failed to update quantity: $e');
    } finally {
      _setLoading(false);
    }
  }

  void incrementQuantity(String productId) {
    final item = _productService.cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: _productService.getProductById(productId)!, quantity: 0),
    );
    updateQuantity(productId, item.quantity + 1);
  }

  void decrementQuantity(String productId) {
    final item = _productService.cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: _productService.getProductById(productId)!, quantity: 0),
    );
    updateQuantity(productId, item.quantity - 1);
  }

  void clearCart() {
    try {
      _setLoading(true);
      _productService.clearCart();
      _clearError();
    } catch (e) {
      _setError('Failed to clear cart: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Checkout operations
  void toggleCheckoutMode() {
    _isCheckoutMode = !_isCheckoutMode;
    notifyListeners();
  }

  Future<bool> processCheckout() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Simulate checkout process
      await Future.delayed(const Duration(seconds: 2));
      
      // Validate cart
      if (isEmpty) {
        _setError('Cart is empty');
        return false;
      }
      
      // Check stock availability
      for (final item in cartItems) {
        if (item.product.stockQuantity < item.quantity) {
          _setError('Insufficient stock for ${item.product.name}');
          return false;
        }
      }
      
      // Process payment (simulation)
      // In real app, integrate with payment gateway
      
      // Clear cart after successful checkout
      _productService.clearCart();
      _isCheckoutMode = false;
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Checkout failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Product availability checks
  bool isProductAvailable(String productId) {
    final product = _productService.getProductById(productId);
    return product?.isAvailable == true && (product?.stockQuantity ?? 0) > 0;
  }

  int getAvailableStock(String productId) {
    final product = _productService.getProductById(productId);
    return product?.stockQuantity ?? 0;
  }

  String getStockStatus(String productId) {
    final product = _productService.getProductById(productId);
    if (product == null) return 'Product not found';
    
    if (!product.isAvailable) return 'Not available';
    if (product.stockQuantity <= 0) return 'Out of stock';
    if (product.stockQuantity <= 5) return 'Only ${product.stockQuantity} left';
    return 'In stock (${product.stockQuantity})';
  }

  // Cart statistics
  Map<String, int> getCategoryStats() {
    final stats = <String, int>{};
    for (final item in cartItems) {
      stats[item.product.category] = (stats[item.product.category] ?? 0) + item.quantity;
    }
    return stats;
  }

  double getSubtotal() {
    return cartItems.fold(0.0, (total, item) => total + (item.product.price * item.quantity));
  }

  double getTax(double taxRate) {
    return getSubtotal() * taxRate;
  }

  double getTotalWithTax(double taxRate) {
    return getSubtotal() + getTax(taxRate);
  }

  // Search and filter cart items
  List<CartItem> getFilteredCartItems(String query) {
    if (query.isEmpty) return cartItems;
    
    return cartItems.where((item) =>
      item.product.name.toLowerCase().contains(query.toLowerCase()) ||
      item.product.title.toLowerCase().contains(query.toLowerCase()) ||
      item.product.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Helper methods
  CartItem? getCartItem(String productId) {
    try {
      return cartItems.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  double getItemTotal(String productId) {
    final item = getCartItem(productId);
    if (item == null) return 0.0;
    return item.product.price * item.quantity;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _productService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
