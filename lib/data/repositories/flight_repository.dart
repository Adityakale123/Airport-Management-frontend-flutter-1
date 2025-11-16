import '../services/api_service.dart';
import '../models/flight.dart';
import '../../core/constants/api_endpoints.dart';

class FlightRepository {
  // Get all flights (Admin)
  Future<List<Flight>> getAdminFlights() async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminFlights);
      return (response as List).map((json) => Flight.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch flights: ${e.toString()}');
    }
  }

  // Get flight by ID (Admin)
  Future<Flight> getAdminFlightById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminFlightById(id));
      return Flight.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch flight: ${e.toString()}');
    }
  }

  // Get flight by ID (User)
  Future<Flight> getUserFlightById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.userFlightById(id));
      return Flight.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch flight: ${e.toString()}');
    }
  }

  // Create flight (Admin)
  Future<Flight> createFlight(Map<String, dynamic> flightData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.createFlight,
        flightData,
      );
      return Flight.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create flight: ${e.toString()}');
    }
  }

  // Update flight (Admin)
  Future<Flight> updateFlight(int id, Map<String, dynamic> flightData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.updateFlight(id),
        flightData,
      );
      return Flight.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update flight: ${e.toString()}');
    }
  }

  // Delete flight (Admin)
  Future<void> deleteFlight(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.deleteFlight(id));
    } catch (e) {
      throw Exception('Failed to delete flight: ${e.toString()}');
    }
  }

  // Search flights (User)
  Future<List<Flight>> searchFlights(Map<String, dynamic> searchParams) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.searchFlights,
        searchParams,
      );
      return (response as List).map((json) => Flight.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Flight search failed: ${e.toString()}');
    }
  }

  // Get available seats
  Future<List<dynamic>> getAvailableSeats(int flightId) async {
    try {
      final response = await ApiService.get(
        '${ApiEndpoints.availableSeats}?flightId=$flightId',
      );
      return response as List;
    } catch (e) {
      throw Exception('Failed to fetch seats: ${e.toString()}');
    }
  }
}
