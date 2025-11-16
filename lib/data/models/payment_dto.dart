// Create Order Response DTO
class CreateOrderResponseDTO {
  final String orderId;
  final String razorpayKey;
  final int amount;
  final String currency;

  CreateOrderResponseDTO({
    required this.orderId,
    required this.razorpayKey,
    required this.amount,
    required this.currency,
  });

  factory CreateOrderResponseDTO.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponseDTO(
      orderId: json['orderId'] as String,
      razorpayKey: json['razorpayKey'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'razorpayKey': razorpayKey,
      'amount': amount,
      'currency': currency,
    };
  }
}

// Payment Verification DTO
// Payment Verification DTO
class PaymentVerificationDTO {
  final String razorpayPaymentId;
  final String razorpayOrderId;
  final String razorpaySignature;

  PaymentVerificationDTO({
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.razorpaySignature,
  });

  factory PaymentVerificationDTO.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationDTO(
      razorpayPaymentId: json['razorpay_payment_id'] as String, // ✓ snake_case
      razorpayOrderId: json['razorpay_order_id'] as String, // ✓ snake_case
      razorpaySignature: json['razorpay_signature'] as String, // ✓ snake_case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay_payment_id': razorpayPaymentId, // ✓ snake_case
      'razorpay_order_id': razorpayOrderId, // ✓ snake_case
      'razorpay_signature': razorpaySignature, // ✓ snake_case
    };
  }
}
