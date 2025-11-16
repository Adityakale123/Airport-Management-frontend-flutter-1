import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/loading_indicator.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BookingProvider>(context, listen: false).getUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .getUserBookings();
            },
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading payment history...');
          }

          // Get bookings with COMPLETED payment status or non-PENDING status
          final payments = provider.bookings
              .where((b) =>
                  b.paymentStatus == 'COMPLETED' ||
                  b.status == 'CONFIRMED' ||
                  b.status == 'CHECKED_IN' ||
                  b.status == 'BOARDED')
              .toList();

          if (payments.isEmpty) {
            return EmptyState(
              icon: Icons.payment,
              title: 'No Payment History',
              subtitle: 'Your payment transactions will appear here',
              actionText: 'Book a Flight',
              onActionPressed: () {
                Navigator.pushNamed(context, AppRoutes.flightSearch);
              },
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final booking = payments[index];
              return _buildPaymentCard(context, booking);
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, dynamic booking) {
    final isSuccess = booking.paymentStatus == 'COMPLETED' ||
        booking.status == 'CONFIRMED' ||
        booking.status == 'CHECKED_IN' ||
        booking.status == 'BOARDED';

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showPaymentDetails(context, booking),
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
                            '₹${booking.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Flight: ${booking.flight?.number ?? 'N/A'}',
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
                      booking.paymentStatus ?? 'COMPLETED',
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
                booking.pnr ?? booking.id.toString(),
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.event_seat,
                'Seat',
                booking.seatNumber,
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                'Date',
                DateFormatter.formatDate(booking.bookingDate),
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

  void _showPaymentDetails(BuildContext context, dynamic booking) {
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
            _buildDetailRow('Amount', '₹${booking.price.toStringAsFixed(2)}'),
            _buildDetailRow('Flight', booking.flight?.number ?? 'N/A'),
            _buildDetailRow('Seat', booking.seatNumber),
            _buildDetailRow('Seat Class', booking.seatClass ?? 'N/A'),
            _buildDetailRow('Status', booking.status),
            _buildDetailRow(
                'Payment Status', booking.paymentStatus ?? 'COMPLETED'),
            _buildDetailRow(
                'Booking PNR', booking.pnr ?? booking.id.toString()),
            _buildDetailRow(
              'Date & Time',
              DateFormatter.formatDateTime(booking.bookingDate),
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
