import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/custom_button.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({Key? key, required this.bookingId})
      : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    await Provider.of<BookingProvider>(context, listen: false)
        .getBookingById(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Share booking')),
              );
            },
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading booking details...');
          }

          if (provider.selectedBooking == null) {
            return Center(child: Text('Booking not found'));
          }

          final booking = provider.selectedBooking!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: 64, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Booking Confirmed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'PNR: ${booking.pnr ?? booking.id}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (booking.flight != null) ...[
                        Text(
                          'Flight Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
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
                                              booking.flight!.departureTime),
                                          style: TextStyle(
                                              color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: AppColors.primary),
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
                                              booking.flight!.arrivalTime),
                                          style: TextStyle(
                                              color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(height: 24),
                                _buildInfoRow(
                                  Icons.flight,
                                  'Flight',
                                  '${booking.flight!.number} - ${booking.flight!.airline}',
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  'Date',
                                  DateFormatter.formatDate(
                                      booking.flight!.departureTime),
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.schedule,
                                  'Duration',
                                  booking.flight!.duration,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      if (booking.passenger != null) ...[
                        Text(
                          'Passenger Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.person,
                                  'Name',
                                  booking.passenger!.name,
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.email,
                                  'Email',
                                  booking.passenger!.email,
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.phone,
                                  'Phone',
                                  booking.passenger!.phone,
                                ),
                                SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.event_seat,
                                  'Seat',
                                  booking.seatNo,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Amount Paid',
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                    '₹${booking.amount}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Booking Date'),
                                  Text(DateFormatter.formatDate(
                                      booking.bookingDate)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Status'),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking.status)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      booking.status,
                                      style: TextStyle(
                                        color: _getStatusColor(booking.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      if (booking.status == 'CONFIRMED') ...[
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Download Ticket',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.ticket,
                                    arguments: booking.id,
                                  );
                                },
                                icon: Icons.download,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: 'Check In',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Check-in functionality')),
                                  );
                                },
                                icon: Icons.flight_takeoff,
                                isOutlined: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (booking.status == 'BOARDED') ...[
                        CustomButton(
                          text: 'View Ticket',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.ticket,
                              arguments: booking.id,
                            );
                          },
                          icon: Icons.confirmation_number,
                          width: double.infinity,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.grey),
        SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: AppColors.textSecondary)),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return AppColors.success;
      case 'CHECKED_IN':
        return AppColors.info;
      case 'BOARDED':
        return AppColors.boarding;
      case 'CANCELLED':
        return AppColors.cancelled;
      default:
        return AppColors.grey;
    }
  }
}
