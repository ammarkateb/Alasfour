import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';

class FinalScreenController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  // UI-specific state
  List<Product> _promotions = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  int _selectedCategory = 0;
  bool _isRefreshing = false;

  // Public getters
  List<Product> get promotions => _filteredPromotions;
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  int get selectedCategory => _selectedCategory;
  bool get isRefreshing => _isRefreshing;

  // Categories
  final List<String> categories = ['الكل', 'بقوليات', 'مشروبات', 'حلويات', 'تمور'];

  // Get filtered products based on search and category
  List<Product> get _filteredProducts {
    var products = _productService.products;
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Filter by category
    if (_selectedCategory > 0) {
      products = products.where((product) =>
        product.category == categories[_selectedCategory]
      ).toList();
    }
    
    return products;
  }

  // Get filtered promotions (products with special discounts)
  List<Product> get _filteredPromotions {
    var promotions = _productService.products.where((product) =>
      product.price < 3.0 // Consider products under 3 KD as promotions
    ).toList();
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      promotions = promotions.where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.title.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return promotions.take(3).toList(); // Show top 3 promotions
  }

  FinalScreenController() {
    _loadHomeData();
    
    // Listen to service changes
    _productService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  // Load home data
  Future<void> _loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Initialize product service if not already done
      await _productService.initialize();
      
      // Set promotions (products with discounts)
      _promotions = _productService.products.where((product) =>
        product.price < 3.0
      ).toList();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    _isRefreshing = true;
    notifyListeners();
    
    await _productService.refresh();
    await _loadHomeData();
    
    _isRefreshing = false;
    notifyListeners();
  }

  // Search promotions
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Select category
  void selectCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Get product by ID
  Product? getProductById(String id) {
    return _productService.getProductById(id);
  }

  // Get active promotions (products with discounts)
  List<Product> get activePromotions => _filteredPromotions;

  // Get expiring promotions (low stock products)
  List<Product> get expiringPromotions {
    return _productService.lowStockProducts.take(3).toList();
  }

  // Participate in promotion (add to cart)
  Future<bool> participateInPromotion(String productId) async {
    try {
      _productService.addToCart(productId);
      return true;
    } catch (e) {
      _error = 'فشل في المشاركة في العرض: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Share promotion
  Future<bool> sharePromotion(String productId) async {
    try {
      final product = getProductById(productId);
      if (product != null) {
        // In real app, use share package
        debugPrint('Sharing promotion: ${product.name}');
        return true;
      }
      return false;
    } catch (e) {
      _error = 'فشل في مشاركة العرض: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Get user points history (mock)
  List<Map<String, dynamic>> get pointsHistory {
    return [
      {'type': 'earned', 'points': 50, 'reason': 'مشاركة في السحب', 'date': '2024-01-15'},
      {'type': 'redeemed', 'points': -100, 'reason': 'خصم على المنتجات', 'date': '2024-01-10'},
      {'type': 'earned', 'points': 200, 'reason': 'فائز في السحب الشهري', 'date': '2024-01-05'},
    ];
  }

  // Get notification count
  int get notificationCount {
    // In real app, this would come from notifications controller
    return 5;
  }

  // Get home stats from ProductService
  Map<String, dynamic> get stats {
    return {
      'totalProducts': _productService.products.length,
      'activePromotions': activePromotions.length,
      'totalWinners': 1247, // Mock data
      'userPoints': 850, // Mock data
    };
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Update user stats (mock)
  void updateUserStats() {
    notifyListeners();
  }

  @override
  void dispose() {
    _productService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
