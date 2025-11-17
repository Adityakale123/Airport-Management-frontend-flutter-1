import 'package:flutter/foundation.dart';
import '../../data/models/billing.dart';
import '../../data/repositories/billing_repository.dart';

class BillingProvider with ChangeNotifier {
  final BillingRepository _repository = BillingRepository();

  BillingData? _billingData;
  List<Invoice>? _invoices;
  List<Payment>? _payments;
  bool _isLoading = false;
  String? _errorMessage;

  BillingData? get billingData => _billingData;
  List<Invoice>? get invoices => _invoices;
  List<Payment>? get payments => _payments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getBillingData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _billingData = await _repository.getBillingData();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error getting billing data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _invoices = await _repository.getInvoices();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error getting invoices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPayments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payments = await _repository.getPayments();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error getting payments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
