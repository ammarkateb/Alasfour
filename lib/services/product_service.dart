import 'package:flutter/foundation.dart';
import '../models/product.dart';

// Central Product Management Service
class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  // Core data
  List<Product> _allProducts = [];
  List<CartItem> _cartItems = [];
  Map<String, Product> _productCache = {};
  
  // State
  bool _isLoading = false;
  String? _error;
  ProductFilter _currentFilter = const ProductFilter();
  String _searchQuery = '';
  
  // Caching
  DateTime? _lastCacheUpdate;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  // Public getters
  List<Product> get products => _filteredProducts;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  bool get isLoading => _isLoading;
  String? get error => _error;
  ProductFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  
  // Computed properties
  List<Product> get _filteredProducts {
    var filtered = _allProducts;
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Apply filter
    if (_currentFilter.category != null && _currentFilter.category != 'all') {
      filtered = filtered.where((p) => p.category == _currentFilter.category).toList();
    }
    
    if (_currentFilter.minPrice != null) {
      filtered = filtered.where((p) => p.price >= _currentFilter.minPrice!).toList();
    }
    
    if (_currentFilter.maxPrice != null) {
      filtered = filtered.where((p) => p.price <= _currentFilter.maxPrice!).toList();
    }
    
    if (_currentFilter.onlyAvailable == true) {
      filtered = filtered.where((p) => p.isAvailable).toList();
    }
    
    if (_currentFilter.onlyFavorites == true) {
      filtered = filtered.where((p) => p.isFavorite).toList();
    }
    
    return filtered;
  }
  
  // Cart computed properties
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  // Product statistics
  Map<String, int> get categoryCount {
    final counts = <String, int>{};
    for (final product in _allProducts) {
      counts[product.category] = (counts[product.category] ?? 0) + 1;
    }
    return counts;
  }
  
  List<Product> get favoriteProducts => _allProducts.where((p) => p.isFavorite).toList();
  List<Product> get availableProducts => _allProducts.where((p) => p.isAvailable).toList();
  List<Product> get lowStockProducts => _allProducts.where((p) => p.stockQuantity < 5).toList();

  // Initialize service
  Future<void> initialize() async {
    await loadProducts(forceRefresh: false);
  }

  // Load products with caching
  Future<void> loadProducts({bool forceRefresh = false}) async {
    // Check cache first
    if (!forceRefresh && _isCacheValid()) {
      _notifyIfChanged();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call - in real app, replace with actual API
      await Future.delayed(const Duration(milliseconds: 800));
      
      final products = await _fetchProductsFromApi();
      
      _allProducts = products;
      _updateCache();
      
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Simulated API call - replace with real implementation
  Future<List<Product>> _fetchProductsFromApi() async {
    // Mock data - in real app, this would be an HTTP request
    return [
      Product(
        id: '1',
        name: 'بقوليات العصفور',
        title: 'بقوليات العصفور',
        subtitle: 'الطعم الأصيل، الجودة العالية',
        description: 'منتجات بقوليات عالية الجودة من العصفور',
        imagePath: 'assets/images/598860259_1334461122027100_5329054173698521768_n.jpg',
        price: 2.50,
        category: 'بقوليات',
        stockQuantity: 100,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: '2',
        name: 'رز إسباني',
        title: 'رز إسباني',
        subtitle: 'لما يكون الأكل زاكي',
        description: 'أجود أنواع الأرز الإسباني',
        imagePath: 'assets/images/514348169_1192444092895471_42307.png',
        price: 3.75,
        category: 'أرز',
        stockQuantity: 50,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Product(
        id: '3',
        name: 'حلاوة بالفستق',
        title: 'حلاوة بالفستق',
        subtitle: 'طعم غني بالفستق',
        description: 'حلاوة عالية الجودة بالفستق الطبيعي',
        imagePath: 'assets/images/605327917_1339959141477298_3665058675691574909_n.jpg',
        price: 4.25,
        category: 'حلويات',
        stockQuantity: 30,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Product(
        id: '4',
        name: 'شاي العصفور',
        title: 'شاي العصفور',
        subtitle: 'استمتعوا بكوب شاي أصيل',
        description: 'شاي عالي الجودة من العصفور',
        imagePath: 'assets/images/556815123_1269799431826603_5966544853180279500_n.jpg',
        price: 1.50,
        category: 'مشروبات',
        stockQuantity: 200,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: '5',
        name: 'زعتر العصفور الاحمر',
        title: 'زعتر العصفور الاحمر',
        subtitle: 'تربح مع العصفور',
        description: 'زعتر عالي الجودة من العصفور',
        imagePath: 'assets/images/488908302_1123782413094973_3503546681784529641_n-removebg-preview.png',
        price: 2.00,
        category: 'بهارات',
        stockQuantity: 75,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '6',
        name: 'تمر العصفور',
        title: 'تمر العصفور',
        subtitle: 'الطعم اللي بيجمع بين النكهات',
        description: 'تمر عالي الجودة من العصفور',
        imagePath: 'assets/images/587716668_1318152896991256_7151570163319648168_n.jpg',
        price: 5.50,
        category: 'تمور',
        stockQuantity: 25,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
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

  // Filter functionality
  void updateFilter(ProductFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void clearFilter() {
    _currentFilter = const ProductFilter();
    notifyListeners();
  }

  // Product operations
  Product? getProductById(String id) {
    return _allProducts.where((p) => p.id == id).firstOrNull;
  }

  Future<void> toggleFavorite(String productId) async {
    final productIndex = _allProducts.indexWhere((p) => p.id == productId);
    if (productIndex == -1) return;

    final product = _allProducts[productIndex];
    _allProducts[productIndex] = product.copyWith(isFavorite: !product.isFavorite);
    
    // Update cache
    _productCache[productId] = _allProducts[productIndex];
    
    // In real app, also update on server
    await _updateFavoriteOnServer(productId, _allProducts[productIndex].isFavorite);
    
    notifyListeners();
  }

  Future<void> updateProductStock(String productId, int newQuantity) async {
    final productIndex = _allProducts.indexWhere((p) => p.id == productId);
    if (productIndex == -1) return;

    final product = _allProducts[productIndex];
    _allProducts[productIndex] = product.copyWith(
      stockQuantity: newQuantity,
      updatedAt: DateTime.now(),
    );
    
    _productCache[productId] = _allProducts[productIndex];
    
    // Update on server
    await _updateStockOnServer(productId, newQuantity);
    
    notifyListeners();
  }

  // Cart operations
  void addToCart(String productId, {int quantity = 1}) {
    final product = getProductById(productId);
    if (product == null || !product.isAvailable) return;

    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == productId);
    
    if (existingItemIndex != -1) {
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
  }

  void updateCartItemQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item.product.id == productId);
    if (itemIndex == -1) return;

    _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(quantity: quantity);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Cache management
  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) < _cacheTimeout;
  }

  void _updateCache() {
    _lastCacheUpdate = DateTime.now();
    _productCache = {for (var product in _allProducts) product.id: product};
  }

  void clearCache() {
    _productCache.clear();
    _lastCacheUpdate = null;
  }

  // Server operations (mock implementations)
  Future<void> _updateFavoriteOnServer(String productId, bool isFavorite) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('Updated favorite for $productId: $isFavorite');
  }

  Future<void> _updateStockOnServer(String productId, int quantity) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('Updated stock for $productId: $quantity');
  }

  // Utility methods
  void _notifyIfChanged() {
    // Only notify if there are actual changes
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await loadProducts(forceRefresh: true);
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
}
