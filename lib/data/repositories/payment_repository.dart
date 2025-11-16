import '../services/api_service.dart';
import '../models/payment.dart';
import '../models/payment_dto.dart';
import '../../core/constants/api_endpoints.dart';

class PaymentRepository {
  // Process payment
  Future<Payment> processPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.processPayment,
        paymentData,
      );
      return Payment.fromJson(response);
    } catch (e) {
      throw Exception('Payment failed: ${e.toString()}');
    }
  }

  // Get payment history
  Future<List<Payment>> getPaymentHistory() async {
    try {
      final response = await ApiService.get(ApiEndpoints.paymentHistory);
      return (response as List).map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch payment history: ${e.toString()}');
    }
  }

  // Get payment details
  Future<Payment> getPaymentDetails(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.paymentDetails(id));
      return Payment.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch payment details: ${e.toString()}');
    }
  }

  // Razorpay: Create order for booking
  Future<CreateOrderResponseDTO> createOrderForBooking(int bookingId) async {
    try {
      final response = await ApiService.post(
        '/user/payments/create-order/$bookingId',
        {},
      );
      return CreateOrderResponseDTO.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create payment order: ${e.toString()}');
    }
  }

  // Razorpay: Verify payment and confirm booking
  Future<void> verifyPayment(PaymentVerificationDTO verificationData) async {
    try {
      await ApiService.post(
        '/user/payments/verify',
        verificationData.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to verify payment: ${e.toString()}');
    }
  }
}

