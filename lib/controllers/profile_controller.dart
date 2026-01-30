import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String phone;
  final String email;
  final String region;
  final String? profileImagePath;

  UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.region,
    this.profileImagePath,
  });

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    String? region,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      region: region ?? this.region,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}

class ProfileController extends ChangeNotifier {
  UserProfile _profile = UserProfile(
    name: 'أحمد محمد',
    phone: '+965 9876 5432',
    email: 'ahmed@example.com',
    region: 'الكويت',
  );

  bool _isLoading = false;
  String? _error;

  // Public getters
  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Update profile information
  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? region,
  }) {
    _profile = _profile.copyWith(
      name: name,
      phone: phone,
      email: email,
      region: region,
    );
    notifyListeners();
  }

  // Update profile image
  void updateProfileImage(String imagePath) {
    _profile = _profile.copyWith(profileImagePath: imagePath);
    notifyListeners();
  }

  // Save profile changes (simulated API call)
  Future<void> saveProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // In real app, this would save to backend
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout functionality
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate logout API call
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset profile to defaults
  void resetProfile() {
    _profile = UserProfile(
      name: 'أحمد محمد',
      phone: '+965 9876 5432',
      email: 'ahmed@example.com',
      region: 'الكويت',
    );
    notifyListeners();
  }
}
