import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';
import '../../core/constants/api_endpoints.dart';

class AuthRepository {
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.login,
        {'email': email, 'password': password},
      );

      // Save token and user
      if (response['token'] != null) {
        await LocalStorageService.saveToken(response['token']);
      }

      final user = User.fromJson(response);
      await LocalStorageService.saveUser(user);

      return response;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.post(ApiEndpoints.register, userData);
      return response;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await ApiService.post(ApiEndpoints.logout, {});
      await LocalStorageService.deleteToken();
      await LocalStorageService.deleteUser();
    } catch (e) {
      // Even if API call fails, clear local data
      await LocalStorageService.deleteToken();
      await LocalStorageService.deleteUser();
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await ApiService.post(ApiEndpoints.forgotPassword, {'email': email});
    } catch (e) {
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  // Reset Password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await ApiService.post(
        ApiEndpoints.resetPassword,
        {'token': token, 'password': newPassword},
      );
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Get Current User
  Future<User?> getCurrentUser() async {
    return await LocalStorageService.getUser();
  }

  // Check if authenticated
  Future<bool> isAuthenticated() async {
    final token = await LocalStorageService.getToken();
    return token != null;
  }
}
