import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';
import '../../core/constants/api_endpoints.dart';

class UserRepository {
  // Get user profile
  Future<User> getProfile() async {
    try {
      final response = await ApiService.get(ApiEndpoints.userProfile);
      final user = User.fromJson(response);
      await LocalStorageService.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  // Update profile
  Future<User> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.updateProfile,
        profileData,
      );
      final user = User.fromJson(response);
      await LocalStorageService.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Change password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await ApiService.post(
        ApiEndpoints.changePassword,
        {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
}