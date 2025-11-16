import 'package:flutter/foundation.dart';
import '../../data/models/booking.dart';
import '../../data/repositories/booking_repository.dart';

class BookingProvider with ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();

  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _errorMessage;

  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get user bookings
  Future<void> getUserBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _bookingRepository.getUserBookings();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get booking by ID
  Future<void> getBookingById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedBooking = await _bookingRepository.getBookingById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create booking
  Future<Booking?> createBooking(Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final booking = await _bookingRepository.createBooking(bookingData);
      _bookings.add(booking);
      _selectedBooking = booking;
      notifyListeners();
      return booking;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
    }
  }

  // Update booking
  Future<bool> updateBooking(int id, Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedBooking =
          await _bookingRepository.updateBooking(id, bookingData);
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bookingRepository.cancelBooking(id);
      _bookings.removeWhere((b) => b.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Select booking
  void selectBooking(Booking booking) {
    _selectedBooking = booking;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedBooking = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<List<String>> getOccupiedSeatsForFlight(int flightId) async {
    try {
      final occupiedSeats = await _bookingRepository.getOccupiedSeatsForFlight(flightId);
      return occupiedSeats;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }
}
