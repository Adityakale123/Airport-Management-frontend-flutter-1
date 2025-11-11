import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/custom_button.dart';

class AdminFlightDetailsScreen extends StatefulWidget {
  final int flightId;

  const AdminFlightDetailsScreen({Key? key, required this.flightId})
      : super(key: key);

  @override
  State<AdminFlightDetailsScreen> createState() =>
      _AdminFlightDetailsScreenState();
}

class _AdminFlightDetailsScreenState extends State<AdminFlightDetailsScreen> {
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
            icon: Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit functionality')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.error),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Delete functionality')),
              );
            },
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading flight details...');
          }

          if (provider.selectedFlight == null) {
            return Center(child: Text('Flight not found'));
          }

          final flight = provider.selectedFlight!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.number,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        flight.airline,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 16),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormatter.formatTime(flight.departureTime),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.destination,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormatter.formatTime(flight.arrivalTime),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Flight Information'),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow('Flight Number', flight.number),
                              Divider(height: 24),
                              _buildInfoRow('Airline', flight.airline),
                              Divider(height: 24),
                              _buildInfoRow('Status', flight.status),
                              Divider(height: 24),
                              _buildInfoRow(
                                'Departure',
                                DateFormatter.formatDateTime(
                                    flight.departureTime),
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                'Arrival',
                                DateFormatter.formatDateTime(
                                    flight.arrivalTime),
                              ),
                              Divider(height: 24),
                              _buildInfoRow('Duration', flight.duration),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Aircraft & Terminal'),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Aircraft Type',
                                flight.aircraftType ?? 'Not specified',
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                  'Terminal', flight.terminal ?? 'TBA'),
                              Divider(height: 24),
                              _buildInfoRow('Gate', flight.gate ?? 'TBA'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Capacity & Pricing'),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Total Seats',
                                flight.totalSeats.toString(),
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                'Available Seats',
                                flight.availableSeats.toString(),
                              ),
                              Divider(height: 24),
                              _buildInfoRow(
                                'Booked Seats',
                                '${flight.totalSeats - flight.availableSeats}',
                              ),
                              Divider(height: 24),
                              _buildInfoRow('Base Price', '₹${flight.price}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Update Status',
                              onPressed: () {
                                _showStatusUpdateDialog();
                              },
                              isOutlined: true,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'View Bookings',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'View bookings for this flight')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
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

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Flight Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select new status for this flight:'),
            // Add status selection UI here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Status updated')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
