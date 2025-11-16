import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for payment operations
/// Helps generate test signatures that backend can validate
class PaymentUtils {
  // Generate a test HMAC signature similar to Razorpay
  // This is for web/test environment only
  static String generateTestSignature(
    String orderId,
    String paymentId,
    String razorpaySecret,
  ) {
    final message = '$orderId|$paymentId';
    final bytes = utf8.encode(message);
    final secretBytes = utf8.encode(razorpaySecret);
    
    // Generate HMAC-SHA256
    final signature = Hmac(sha256, secretBytes).convert(bytes);
    return signature.toString();
  }

  /// Generate mock Razorpay payment ID for testing
  static String generateTestPaymentId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'pay_test_${timestamp}_web';
  }

  /// Generate mock Razorpay signature for testing
  /// For web environment, this creates a simple test signature
  static String generateTestPaymentSignature() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // In test mode, backend should recognize this pattern
    return 'test_sig_${timestamp}_web_flutter';
  }
}
