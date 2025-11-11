import '../services/api_service.dart';
import '../models/analytics.dart';
import '../../core/constants/api_endpoints.dart';

class AnalyticsRepository {
  // Get overall analytics
  Future<Analytics> getAnalytics() async {
    try {
      final response = await ApiService.get(ApiEndpoints.analytics);
      return Analytics.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch analytics: ${e.toString()}');
    }
  }

  // Get flight analytics
  Future<Map<String, dynamic>> getFlightAnalytics() async {
    try {
      final response = await ApiService.get(ApiEndpoints.flightAnalytics);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch flight analytics: ${e.toString()}');
    }
  }

  // Get booking analytics
  Future<Map<String, dynamic>> getBookingAnalytics() async {
    try {
      final response = await ApiService.get(ApiEndpoints.bookingAnalytics);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch booking analytics: ${e.toString()}');
    }
  }

  // Get revenue analytics
  Future<Map<String, dynamic>> getRevenueAnalytics() async {
    try {
      final response = await ApiService.get(ApiEndpoints.revenueAnalytics);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch revenue analytics: ${e.toString()}');
    }
  }
}
