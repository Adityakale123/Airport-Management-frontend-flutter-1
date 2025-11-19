import 'package:flutter/foundation.dart';
import '../../data/models/payment_dto.dart';
import '../../data/repositories/payment_repository.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();

  CreateOrderResponseDTO? _orderResponse;
  bool _isLoading = false;
  String? _errorMessage;
  bool _paymentSuccess = false;

  CreateOrderResponseDTO? get orderResponse => _orderResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get paymentSuccess => _paymentSuccess;

  // Create Razorpay order for booking
  Future<bool> createOrderForBooking(int bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    _paymentSuccess = false;
    notifyListeners();

    try {
      _orderResponse =
          await _paymentRepository.createOrderForBooking(bookingId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyPayment(
    String razorpayPaymentId,
    String razorpayOrderId,
    String razorpaySignature,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final verificationData = PaymentVerificationDTO(
        razorpayPaymentId: razorpayPaymentId,
        razorpayOrderId: razorpayOrderId,
        razorpaySignature: razorpaySignature,
      );

      await _paymentRepository.verifyPayment(verificationData);
      _paymentSuccess = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear state
  void clearState() {
    _orderResponse = null;
    _errorMessage = null;
    _paymentSuccess = false;
    notifyListeners();
  }
}
