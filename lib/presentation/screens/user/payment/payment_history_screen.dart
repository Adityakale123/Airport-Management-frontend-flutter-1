import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../widgets/common/empty_state.dart';

class PaymentHistoryScreen extends StatelessWidget {
  // Mock data - replace with actual data from provider
  final List<Map<String, dynamic>> _mockPayments = [
    {
      'id': 1,
      'amount': 5000.0,
      'method': 'Credit Card',
      'status': 'COMPLETED',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'transactionId': 'TXN123456789',
      'bookingPnr': 'ABC123',
    },
    {
      'id': 2,
      'amount': 3500.0,
      'method': 'UPI',
      'status': 'COMPLETED',
      'date': DateTime.now().subtract(Duration(days: 15)),
      'transactionId': 'TXN987654321',
      'bookingPnr': 'DEF456',
    },
    {
      'id': 3,
      'amount': 7200.0,
      'method': 'Net Banking',
      'status': 'FAILED',
      'date': DateTime.now().subtract(Duration(days: 30)),
      'transactionId': 'TXN456789123',
      'bookingPnr': 'GHI789',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filter payments')),
              );
            },
          ),
        ],
      ),
      body: _mockPayments.isEmpty
          ? EmptyState(
              icon: Icons.payment,
              title: 'No Payment History',
              subtitle: 'Your payment transactions will appear here',
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _mockPayments.length,
              itemBuilder: (context, index) {
                final payment = _mockPayments[index];
                return _buildPaymentCard(context, payment);
              },
            ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Map<String, dynamic> payment) {
    final isSuccess = payment['status'] == 'COMPLETED';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showPaymentDetails(context, payment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isSuccess ? Icons.check_circle : Icons.cancel,
                          color:
                              isSuccess ? AppColors.success : AppColors.error,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${payment['amount']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            payment['method'],
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSuccess
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      payment['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 24),
              _buildInfoRow(
                Icons.confirmation_number,
                'Booking PNR',
                payment['bookingPnr'],
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.receipt,
                'Transaction ID',
                payment['transactionId'],
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                'Date',
                DateFormatter.formatDate(payment['date']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentDetails(BuildContext context, Map<String, dynamic> payment) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('Amount', '₹${payment['amount']}'),
            _buildDetailRow('Payment Method', payment['method']),
            _buildDetailRow('Status', payment['status']),
            _buildDetailRow('Transaction ID', payment['transactionId']),
            _buildDetailRow('Booking PNR', payment['bookingPnr']),
            _buildDetailRow(
              'Date & Time',
              DateFormatter.formatDateTime(payment['date']),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading receipt...')),
                      );
                    },
                    icon: Icon(Icons.download),
                    label: Text('Download'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sharing receipt...')),
                      );
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
