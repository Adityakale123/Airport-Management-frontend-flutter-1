import 'package:flutter/foundation.dart';
import '../../data/models/flight.dart';
import '../../data/repositories/flight_repository.dart';

class FlightProvider with ChangeNotifier {
  final FlightRepository _flightRepository = FlightRepository();

  List<Flight> _flights = [];
  List<Flight> _searchResults = [];
  Flight? _selectedFlight;
  bool _isLoading = false;
  String? _errorMessage;

  List<Flight> get flights => _flights;
  List<Flight> get searchResults => _searchResults;
  Flight? get selectedFlight => _selectedFlight;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all flights (Admin)
  Future<void> getAdminFlights() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _flights = await _flightRepository.getAdminFlights();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserFlightById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedFlight = await _flightRepository.getUserFlightById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAdminFlightById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedFlight = await _flightRepository.getAdminFlightById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get flight by ID (Admin)

  // Create flight
  Future<bool> createFlight(Map<String, dynamic> flightData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final flight = await _flightRepository.createFlight(flightData);
      _flights.add(flight);
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

  // Update flight
  Future<bool> updateFlight(int id, Map<String, dynamic> flightData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedFlight =
          await _flightRepository.updateFlight(id, flightData);
      final index = _flights.indexWhere((f) => f.id == id);
      if (index != -1) {
        _flights[index] = updatedFlight;
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

  // Delete flight
  Future<bool> deleteFlight(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _flightRepository.deleteFlight(id);
      _flights.removeWhere((f) => f.id == id);
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

  // Search flights
  Future<void> searchFlights(Map<String, dynamic> searchParams) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _flightRepository.searchFlights(searchParams);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select flight
  void selectFlight(Flight flight) {
    _selectedFlight = flight;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedFlight = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
