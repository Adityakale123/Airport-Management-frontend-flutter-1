import '../services/api_service.dart';
import '../models/staff.dart';
import '../../core/constants/api_endpoints.dart';

class StaffRepository {
  // Get all staff members
  Future<List<Staff>> getAllStaff() async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminStaff);
      return (response as List).map((json) => Staff.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch staff: ${e.toString()}');
    }
  }

  // Get staff by ID
  Future<Staff> getStaffById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminStaffById(id));
      return Staff.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch staff: ${e.toString()}');
    }
  }

  // Create staff member
  Future<Staff> createStaff(Map<String, dynamic> staffData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.createStaff,
        staffData,
      );
      return Staff.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create staff: ${e.toString()}');
    }
  }

  // Update staff member
  Future<Staff> updateStaff(int id, Map<String, dynamic> staffData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.updateStaff(id),
        staffData,
      );
      return Staff.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update staff: ${e.toString()}');
    }
  }

  // Delete staff member
  Future<void> deleteStaff(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.deleteStaff(id));
    } catch (e) {
      throw Exception('Failed to delete staff: ${e.toString()}');
    }
  }
}
