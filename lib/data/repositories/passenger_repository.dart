import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class PassengerRepository {
  // Get all user passengers
  Future<List<dynamic>> getUserPassengers() async {
    try {
      final response = await ApiService.get(ApiEndpoints.userPassengers);
      return response as List;
    } catch (e) {
      throw Exception('Failed to fetch passengers: ${e.toString()}');
    }
  }

  // Get passenger by ID
  Future<Map<String, dynamic>> getPassengerById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.userPassengerById(id));
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch passenger: ${e.toString()}');
    }
  }

  // Create passenger
  Future<Map<String, dynamic>> createPassenger(
      Map<String, dynamic> passengerData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.userPassengers,
        passengerData,
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create passenger: ${e.toString()}');
    }
  }

  // Update passenger
  Future<Map<String, dynamic>> updatePassenger(
      int id, Map<String, dynamic> passengerData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.userPassengerById(id),
        passengerData,
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to update passenger: ${e.toString()}');
    }
  }

  // Delete passenger
  Future<void> deletePassenger(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.userPassengerById(id));
    } catch (e) {
      throw Exception('Failed to delete passenger: ${e.toString()}');
    }
  }
}
