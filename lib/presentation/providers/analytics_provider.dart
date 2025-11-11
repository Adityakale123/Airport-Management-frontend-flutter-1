import 'package:flutter/foundation.dart';
import '../../data/models/analytics.dart';
import '../../data/repositories/analytics_repository.dart';

class AnalyticsProvider with ChangeNotifier {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  Analytics? _analytics;
  Map<String, dynamic>? _flightAnalytics;
  Map<String, dynamic>? _bookingAnalytics;
  Map<String, dynamic>? _revenueAnalytics;
  bool _isLoading = false;
  String? _errorMessage;

  Analytics? get analytics => _analytics;
  Map<String, dynamic>? get flightAnalytics => _flightAnalytics;
  Map<String, dynamic>? get bookingAnalytics => _bookingAnalytics;
  Map<String, dynamic>? get revenueAnalytics => _revenueAnalytics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get overall analytics
  Future<void> getAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _analytics = await _analyticsRepository.getAnalytics();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get flight analytics
  Future<void> getFlightAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _flightAnalytics = await _analyticsRepository.getFlightAnalytics();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get booking analytics
  Future<void> getBookingAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookingAnalytics = await _analyticsRepository.getBookingAnalytics();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get revenue analytics
  Future<void> getRevenueAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _revenueAnalytics = await _analyticsRepository.getRevenueAnalytics();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh all analytics
  Future<void> refreshAll() async {
    await getAnalytics();
    await getFlightAnalytics();
    await getBookingAnalytics();
    await getRevenueAnalytics();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
