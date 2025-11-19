import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../providers/booking_provider.dart';
import '../../../../widgets/common/loading_indicator.dart';
import '../../../../widgets/cards/booking_card.dart';

class FlightBookingsScreen extends StatefulWidget {
  final int flightId;
  final String flightNumber;

  const FlightBookingsScreen({
    Key? key,
    required this.flightId,
    required this.flightNumber,
  }) : super(key: key);

  @override
  State<FlightBookingsScreen> createState() => _FlightBookingsScreenState();
}

class _FlightBookingsScreenState extends State<FlightBookingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    await Provider.of<BookingProvider>(context, listen: false)
        .getBookingsByFlight(widget.flightId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight Bookings'),
            Text(
              widget.flightNumber,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading bookings...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadBookings,
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final bookings = provider.flightBookings ?? [];

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This flight has no bookings yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadBookings,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        'Total',
                        bookings.length.toString(),
                        Icons.receipt_long,
                      ),
                      Container(width: 1, height: 40, color: Colors.white30),
                      _buildSummaryItem(
                        'Confirmed',
                        bookings
                            .where((b) => b.status.toUpperCase() == 'CONFIRMED')
                            .length
                            .toString(),
                        Icons.check_circle,
                      ),
                      Container(width: 1, height: 40, color: Colors.white30),
                      _buildSummaryItem(
                        'Pending',
                        bookings
                            .where((b) => b.status.toUpperCase() == 'PENDING')
                            .length
                            .toString(),
                        Icons.schedule,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      // Get passenger name
                      String passengerName = 'N/A';
                      if (booking.passenger != null) {
                        passengerName = '${booking.passenger!.name}';
                      }

                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.airplane_ticket,
                              color: _getStatusColor(booking.status),
                            ),
                          ),
                          title: Text(
                            'PNR: ${booking.pnr ?? "#${booking.id}"}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Passenger: $passengerName'),
                              SizedBox(height: 2),
                              Text(
                                  'Seat: ${booking.seatNumber} (${booking.seatClass})'),
                              SizedBox(height: 2),
                              Text(
                                  'Amount: ₹${booking.price.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              booking.status.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: _getStatusColor(booking.status),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return AppColors.success;
      case 'PENDING':
        return AppColors.warning;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }
}
