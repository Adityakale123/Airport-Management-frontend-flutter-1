import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _user;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  // Check authentication status on init
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authRepository.getCurrentUser();
      _isAuthenticated = await _authRepository.isAuthenticated();
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final response = await _authRepository.login(email, password);
      _user = User.fromJson(response);
      _isAuthenticated = true;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Register - ✅ UPDATED
  Future<bool> register(
    String name,
    String email,
    String password,
    String phone, {
    // ✅ ADD phone parameter
    String? address, // ✅ ADD address parameter (optional)
  }) async {
    try {
      _errorMessage = null;
      notifyListeners();

      await _authRepository.register({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone, // ✅ ADD this
        'address': address, // ✅ ADD this
      });

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // Forgot Password
  Future<bool> forgotPassword(String email) async {
    try {
      _errorMessage = null;
      await _authRepository.forgotPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update user locally
  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Add this to your AuthProvider class
  Future<void> refreshUser() async {
    try {
      final userRepository = UserRepository();
      final updatedUser = await userRepository.getProfile();
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Failed to refresh user: $e');
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final userRepository = UserRepository();
      final updatedUser = await userRepository.updateProfile(profileData);
      _user = updatedUser;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
