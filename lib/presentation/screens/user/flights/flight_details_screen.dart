import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/common/custom_button.dart';

class UserFlightDetailsScreen extends StatefulWidget {
  final int flightId;

  const UserFlightDetailsScreen({Key? key, required this.flightId})
      : super(key: key);

  @override
  State<UserFlightDetailsScreen> createState() =>
      _UserFlightDetailsScreenState();
}

class _UserFlightDetailsScreenState extends State<UserFlightDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadFlightDetails();
  }

  Future<void> _loadFlightDetails() async {
    await Provider.of<FlightProvider>(context, listen: false)
        .getFlightById(widget.flightId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share flight details
            },
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading flight details...');
          }

          if (provider.errorMessage != null) {
            return CustomErrorWidget(
              message: provider.errorMessage!,
              onRetry: _loadFlightDetails,
            );
          }

          if (provider.selectedFlight == null) {
            return Center(child: Text('Flight not found'));
          }

          final flight = provider.selectedFlight!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Flight Header Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.source,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormatter.formatTime(flight.departureTime),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.flight_takeoff,
                                  color: Colors.white, size: 32),
                              SizedBox(height: 4),
                              Text(
                                flight.duration,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.destination,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormatter.formatTime(flight.arrivalTime),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${flight.number} • ${flight.airline}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Flight Details
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Card
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(flight.status)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  flight.status,
                                  style: TextStyle(
                                    color: _getStatusColor(flight.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Flight Information
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
                              _buildInfoRow(
                                Icons.calendar_today,
                                'Date',
                                DateFormatter.formatDate(flight.departureTime),
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                Icons.airplanemode_active,
                                'Aircraft',
                                flight.aircraftType ?? 'Boeing 737',
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                Icons.flight_class,
                                'Terminal',
                                flight.terminal ?? 'Terminal 2',
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                Icons.meeting_room,
                                'Gate',
                                flight.gate ?? 'Gate 12',
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                Icons.event_seat,
                                'Available Seats',
                                '${flight.availableSeats} / ${flight.totalSeats}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Price Information
                      Text(
                        'Fare Details',
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
                                  Text(
                                    'Base Fare',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '₹${flight.price}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Taxes & Fees',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '₹${(flight.price * 0.12).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${(flight.price * 1.12).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.selectedFlight == null) return SizedBox.shrink();

          final flight = provider.selectedFlight!;
          final isSeatsAvailable = flight.availableSeats > 0;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Opacity(
                opacity: isSeatsAvailable ? 1.0 : 0.5,
                child: CustomButton(
                  text: 'Select Seat & Continue',
                  onPressed: isSeatsAvailable
                      ? () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.seatSelection,
                            arguments: flight.id,
                          );
                        }
                      : () {},
                  icon: Icons.event_seat,
                  width: double.infinity,
                  height: 56,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return AppColors.scheduled;
      case 'BOARDING':
        return AppColors.boarding;
      case 'DEPARTED':
        return AppColors.departed;
      case 'ARRIVED':
        return AppColors.arrived;
      case 'DELAYED':
        return AppColors.delayed;
      case 'CANCELLED':
        return AppColors.cancelled;
      default:
        return AppColors.grey;
    }
  }
}
