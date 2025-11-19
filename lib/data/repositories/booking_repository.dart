import '../services/api_service.dart';
import '../models/booking.dart';
import '../../core/constants/api_endpoints.dart';

class BookingRepository {
  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await ApiService.get(ApiEndpoints.userBookings);
      return (response as List).map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: ${e.toString()}');
    }
  }

  Future<Booking> getBookingById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.userBookingById(id));
      return Booking.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch booking: ${e.toString()}');
    }
  }

  Future<List<Booking>> getBookingsByFlight(int flightId) async {
    try {
      final response = await ApiService.get(
        ApiEndpoints.adminBookingsByFlight(flightId),
      );
      return (response as List).map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch flight bookings: ${e.toString()}');
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.createBooking,
        bookingData,
      );
      return Booking.fromJson(response);
    } catch (e) {
      throw Exception('Booking failed: ${e.toString()}');
    }
  }

  Future<Booking> updateBooking(
      int id, Map<String, dynamic> bookingData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.updateBooking(id),
        bookingData,
      );
      return Booking.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  Future<void> cancelBooking(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.deleteBooking(id));
    } catch (e) {
      throw Exception('Failed to cancel booking: ${e.toString()}');
    }
  }

  Future<List<String>> getOccupiedSeatsForFlight(int flightId) async {
    try {
      final response = await ApiService.get(
          '/user/bookings/flight/$flightId/occupied-seats');
      return List<String>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch occupied seats: ${e.toString()}');
    }
  }
}
