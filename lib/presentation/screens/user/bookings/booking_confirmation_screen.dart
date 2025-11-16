import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/custom_button.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final int bookingId;

  const BookingConfirmationScreen({Key? key, required this.bookingId})
      : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadBooking();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadBooking() async {
    await Provider.of<BookingProvider>(context, listen: false)
        .getBookingById(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.userDashboard,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return LoadingIndicator(message: 'Loading booking...');
            }

            if (provider.selectedBooking == null) {
              return Center(child: Text('Booking not found'));
            }

            final booking = provider.selectedBooking!;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 100,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Booking Confirmed!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Your flight has been successfully booked',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Booking Reference',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      booking.pnr ?? booking.id.toString(),
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
                              if (booking.flight != null) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.flight!.source,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormatter.formatTime(
                                            booking.flight!.departureTime,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.primary,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          booking.flight!.destination,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormatter.formatTime(
                                            booking.flight!.arrivalTime,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(height: 32),
                                _buildInfoRow(
                                    'Flight', booking.flight?.number ?? 'N/A'),
                                SizedBox(height: 12),
                                _buildInfoRow(
                                  'Date',
                                  booking.flight != null
                                      ? DateFormatter.formatDate(
                                          booking.flight!.departureTime,
                                        )
                                      : 'N/A',
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow(
                                    'Seat Number', booking.seatNumber),
                                SizedBox(height: 12),
                                _buildInfoRow('Class', booking.seatClass),
                                SizedBox(height: 12),
                                _buildInfoRow('Status', booking.status),
                                SizedBox(height: 12),
                                _buildInfoRow('Amount',
                                    '₹${booking.price.toStringAsFixed(2)}'),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.info.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined, color: AppColors.info),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'A confirmation email has been sent to your registered email address',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        text: 'View Ticket',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.ticket,
                            arguments: booking.id,
                          );
                        },
                        icon: Icons.confirmation_number,
                        width: double.infinity,
                        height: 56,
                      ),
                      SizedBox(height: 12),
                      CustomButton(
                        text: 'Back to Home',
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.userDashboard,
                            (route) => false,
                          );
                        },
                        isOutlined: true,
                        width: double.infinity,
                        height: 56,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
