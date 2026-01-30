import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LoginState { idle, loading, success, error }

class User {
  final String id;
  final String username;
  final String email;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });
}

class LoginController extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  LoginState _loginState = LoginState.idle;
  String? _errorMessage;
  User? _currentUser;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // Public getters
  LoginState get loginState => _loginState;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get rememberMe => _rememberMe;
  bool get isFormValid => usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Toggle remember me
  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  // Validate input
  String? validateUsername(String value) {
    if (value.isEmpty) return 'الرجاء إدخال اسم المستخدم';
    if (value.length < 3) return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'الرجاء إدخال كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  // Login method
  Future<bool> login() async {
    // Validate inputs
    final usernameError = validateUsername(usernameController.text);
    final passwordError = validatePassword(passwordController.text);
    
    if (usernameError != null || passwordError != null) {
      _errorMessage = usernameError ?? passwordError;
      _loginState = LoginState.error;
      notifyListeners();
      return false;
    }

    _loginState = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate authentication logic
      if (_simulateAuthentication(usernameController.text, passwordController.text)) {
        _currentUser = User(
          id: '1',
          username: usernameController.text,
          email: '${usernameController.text}@alasfour.com',
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        
        _loginState = LoginState.success;
        
        // Save user session if remember me is checked
        if (_rememberMe) {
          await _saveUserSession();
        }
        
        return true;
      } else {
        _errorMessage = 'اسم المستخدم أو كلمة المرور غير صحيحة';
        _loginState = LoginState.error;
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}';
      _loginState = LoginState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Simulate authentication (in real app, this would call an API)
  bool _simulateAuthentication(String username, String password) {
    // Mock credentials for demo
    final mockUsers = {
      'admin': '123456',
      'user': 'password',
      'test': 'test123',
    };
    
    return mockUsers[username] == password;
  }

  // Save user session (mock implementation)
  Future<void> _saveUserSession() async {
    // In real app, use secure storage like flutter_secure_storage
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('User session saved');
  }

  // Logout
  Future<void> logout() async {
    _loginState = LoginState.loading;
    notifyListeners();

    try {
      // Simulate logout API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = null;
      _loginState = LoginState.idle;
      
      // Clear controllers
      usernameController.clear();
      passwordController.clear();
      
      // Clear saved session
      await _clearUserSession();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Clear user session
  Future<void> _clearUserSession() async {
    // In real app, clear secure storage
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('User session cleared');
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In real app, send reset email
      debugPrint('Password reset email sent to: $email');
      return true;
    } catch (e) {
      _errorMessage = 'فشل في إرسال بريد إعادة تعيين كلمة المرور: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      // In real app, check secure storage for valid token
      await Future.delayed(const Duration(milliseconds: 100));
      return _currentUser != null;
    } catch (e) {
      return false;
    }
  }

  // Auto-login if remember me was checked
  Future<User?> autoLogin() async {
    try {
      // In real app, retrieve saved credentials from secure storage
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock auto-login for demo
      if (_rememberMe) {
        _currentUser = User(
          id: '1',
          username: 'saved_user',
          email: 'saved_user@alasfour.com',
          token: 'saved_token',
        );
        _loginState = LoginState.success;
        notifyListeners();
        return _currentUser;
      }
      return null;
    } catch (e) {
      _errorMessage = 'فشل في تسجيل الدخول التلقائي: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    usernameController.clear();
    passwordController.clear();
    _errorMessage = null;
    _loginState = LoginState.idle;
    _isPasswordVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
