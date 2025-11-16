import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class PaymentScreen extends StatefulWidget {
  final int bookingId;

  const PaymentScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();
    _nameController = TextEditingController();

    // Create order on load
    Future.microtask(() => _createOrder());
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createOrder() async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    await paymentProvider.createOrderForBooking(widget.bookingId);
  }

  Future<void> _submitPayment() async {
    if (_cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all payment details'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    if (paymentProvider.orderResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order not created. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // For web, simulate payment success (in production, integrate with payment gateway)
    // This is a placeholder for actual payment processing
    try {
      // For web/test environment, generate proper test transaction IDs
      // In production, this would come from actual payment gateway
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final paymentId = 'pay_$timestamp';
      final orderId = paymentProvider.orderResponse!.orderId;
      
      print('💳 Payment Submission:');
      print('  Payment ID: $paymentId');
      print('  Order ID: $orderId');
      
      final verified = await paymentProvider.verifyPayment(
        paymentId,
        orderId,
        'test_sig_$timestamp',
      );

      if (verified && mounted) {
        // Reload bookings to get updated status
        await bookingProvider.getUserBookings();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to confirmation
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.bookingConfirmation,
          arguments: widget.bookingId,
        );
      } else if (mounted) {
        final errorMsg = paymentProvider.errorMessage ?? 'Payment verification failed';
        print('❌ Payment Error: $errorMsg');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print('❌ Payment Exception: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Creating order...');
          }

          if (provider.orderResponse == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? 'Failed to create order',
                    style: TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _createOrder,
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final amount =
              (provider.orderResponse!.amount / 100).toStringAsFixed(2);

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Details
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order ID:'),
                          Text(
                            provider.orderResponse!.orderId,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Amount:'),
                          Text(
                            '₹$amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Payment Form
                Text(
                  'Card Details (Test Mode)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Card Holder Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'John Doe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16),

                // Card Number
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '4111 1111 1111 1111',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Expiry and CVV
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expiryController,
                        decoration: InputDecoration(
                          labelText: 'Expiry (MM/YY)',
                          hintText: '12/25',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Test Card Info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🧪 TEST MODE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Test Card: 4111 1111 1111 1111\nExpiry: Any future date (MM/YY)\nCVV: Any 3 digits',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.amber[900],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Note: This creates a test transaction. Real payments use Razorpay gateway.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.amber[900],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Pay ₹$amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
