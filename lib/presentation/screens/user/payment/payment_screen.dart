import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class PaymentScreen extends StatefulWidget {
  final int bookingId;

  const PaymentScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _paymentMethod = 'CARD';
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (_paymentMethod == 'CARD' && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isProcessing = false);

    // Navigate to confirmation
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.bookingConfirmation,
      arguments: widget.bookingId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildPaymentMethodCard(
              'Credit/Debit Card',
              'CARD',
              Icons.credit_card,
            ),
            SizedBox(height: 12),
            _buildPaymentMethodCard(
              'UPI',
              'UPI',
              Icons.qr_code,
            ),
            SizedBox(height: 12),
            _buildPaymentMethodCard(
              'Net Banking',
              'NET_BANKING',
              Icons.account_balance,
            ),
            SizedBox(height: 12),
            _buildPaymentMethodCard(
              'Wallet',
              'WALLET',
              Icons.account_balance_wallet,
            ),
            SizedBox(height: 24),
            if (_paymentMethod == 'CARD') ...[
              Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _cardNumberController,
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Card number is required';
                        }
                        if (value.replaceAll(' ', '').length != 16) {
                          return 'Invalid card number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _cardHolderController,
                      labelText: 'Card Holder Name',
                      hintText: 'John Doe',
                      prefixIcon: Icons.person,
                      validator: Validators.validateName,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _expiryController,
                            labelText: 'Expiry (MM/YY)',
                            hintText: '12/25',
                            prefixIcon: Icons.calendar_today,
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                return 'Invalid format';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            controller: _cvvController,
                            labelText: 'CVV',
                            hintText: '123',
                            prefixIcon: Icons.lock,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (value.length != 3) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (_paymentMethod == 'UPI') ...[
              Text(
                'UPI Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              CustomTextField(
                labelText: 'UPI ID',
                hintText: 'yourname@upi',
                prefixIcon: Icons.phone_android,
              ),
            ],
            if (_paymentMethod == 'NET_BANKING') ...[
              Text(
                'Select Your Bank',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Bank',
                  prefixIcon: Icon(Icons.account_balance),
                  filled: true,
                  fillColor: AppColors.greyLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  'State Bank of India',
                  'HDFC Bank',
                  'ICICI Bank',
                  'Axis Bank',
                  'Punjab National Bank',
                ].map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ],
            if (_paymentMethod == 'WALLET') ...[
              Text(
                'Select Wallet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildWalletOption('Paytm'),
              SizedBox(height: 8),
              _buildWalletOption('PhonePe'),
              SizedBox(height: 8),
              _buildWalletOption('Google Pay'),
            ],
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹5,000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Pay Now',
              onPressed: _handlePayment,
              isLoading: _isProcessing,
              icon: Icons.payment,
              width: double.infinity,
              height: 56,
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 16, color: AppColors.success),
                  SizedBox(width: 4),
                  Text(
                    'Secure Payment',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, String value, IconData icon) {
    final isSelected = _paymentMethod == value;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.greyLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.grey,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletOption(String name) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: AppColors.primary),
        title: Text(name),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}