import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';

// UI-specific ProductsController that wraps the ProductService
class ProductsController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  // State for UI-specific logic
  String _searchQuery = '';
  String _selectedCategory = 'all';
  bool _isGridView = true;
  Product? _selectedProduct;

  // Public getters
  List<Product> get products => _filteredProducts;
  bool get isLoading => _productService.isLoading;
  String? get error => _productService.error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isGridView => _isGridView;
  Product? get selectedProduct => _selectedProduct;
  
  // Delegate to service
  List<CartItem> get cartItems => _productService.cartItems;
  int get cartItemCount => _productService.cartItemCount;
  double get cartTotalPrice => _productService.cartTotalPrice;
  List<Product> get favoriteProducts => _productService.favoriteProducts;

  // Get filtered products based on UI state
  List<Product> get _filteredProducts {
    var products = _productService.products;
    
    // Apply category filter
    if (_selectedCategory != 'all') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }
    
    // Apply search (service already handles this, but we can add UI-specific search if needed)
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return products;
  }

  ProductsController() {
    // Initialize service if not already done
    _productService.initialize();
    
    // Listen to service changes
    _productService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    // Re-notify UI listeners when service changes
    notifyListeners();
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Category filtering
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // View toggle
  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  // Product operations (delegate to service)
  Future<void> toggleFavorite(String productId) async {
    await _productService.toggleFavorite(productId);
    notifyListeners();
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    _productService.addToCart(productId, quantity: quantity);
  }

  void updateCartItemQuantity(String productId, int quantity) {
    _productService.updateCartItemQuantity(productId, quantity);
  }

  void removeFromCart(String productId) {
    _productService.removeFromCart(productId);
  }

  void clearCart() {
    _productService.clearCart();
  }

  // Product lookup
  Product? getProductById(String id) {
    return _productService.getProductById(id);
  }

  // Refresh data
  Future<void> refreshProducts() async {
    await _productService.refresh();
  }

  // Categories for UI
  List<String> get availableCategories {
    final categories = ['all'];
    final categorySet = _productService.products.map((p) => p.category).toSet();
    categories.addAll(categorySet);
    return categories;
  }

  // Statistics for UI
  Map<String, int> get categoryStats => _productService.categoryCount;
  int get totalProductsCount => _productService.products.length;
  int get availableProductsCount => _productService.availableProducts.length;
  int get favoriteProductsCount => _productService.favoriteProducts.length;

  // Product selection methods for Step 3
  void selectProduct(int index) {
    if (index >= 0 && index < products.length) {
      _selectedProduct = products[index];
      notifyListeners();
    }
  }

  void selectProductById(String id) {
    try {
      _selectedProduct = products.firstWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      // Product not found
      _selectedProduct = null;
      notifyListeners();
    }
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _productService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
