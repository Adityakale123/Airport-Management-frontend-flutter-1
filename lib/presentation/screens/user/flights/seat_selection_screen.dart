import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/flight_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/custom_button.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int flightId;

  const SeatSelectionScreen({Key? key, required this.flightId}) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? _selectedSeat;
  List<String> _occupiedSeats = ['1A', '1B', '2C', '3D', '4E', '5F'];
  
  final int _rows = 20;
  final List<String> _columns = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Seat'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showSeatLegend,
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.selectedFlight == null) {
            return LoadingIndicator();
          }

          final flight = provider.selectedFlight!;

          return Column(
            children: [
              // Flight Info Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: AppColors.primary.withOpacity(0.1),
                child: Column(
                  children: [
                    Text(
                      '${flight.source} → ${flight.destination}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Flight ${flight.number}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Seat Legend
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem('Available', AppColors.success),
                    _buildLegendItem('Selected', AppColors.primary),
                    _buildLegendItem('Occupied', AppColors.grey),
                  ],
                ),
              ),

              // Seat Map
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Cockpit
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.flight_takeoff, color: AppColors.primary),
                          ),
                        ),

                        // Seat Grid
                        ...List.generate(_rows, (rowIndex) {
                          final rowNumber = rowIndex + 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Left side seats (A, B, C)
                                ..._columns.sublist(0, 3).map((col) {
                                  final seatNumber = '$rowNumber$col';
                                  return _buildSeat(seatNumber);
                                }),
                                
                                // Aisle
                                SizedBox(width: 40),
                                
                                // Right side seats (D, E, F)
                                ..._columns.sublist(3, 6).map((col) {
                                  final seatNumber = '$rowNumber$col';
                                  return _buildSeat(seatNumber);
                                }),
                              ],
                            ),
                          );
                        }),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _selectedSeat != null
          ? Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Seat:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedSeat!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: 'Continue to Passenger Details',
                      onPressed: () => _navigateToPassengerDetails(),
                      icon: Icons.arrow_forward,
                      width: double.infinity,
                      height: 56,
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildSeat(String seatNumber) {
    final isOccupied = _occupiedSeats.contains(seatNumber);
    final isSelected = _selectedSeat == seatNumber;

    Color seatColor;
    if (isOccupied) {
      seatColor = AppColors.grey;
    } else if (isSelected) {
      seatColor = AppColors.primary;
    } else {
      seatColor = AppColors.success;
    }

    return GestureDetector(
      onTap: isOccupied ? null : () {
        setState(() {
          _selectedSeat = seatNumber;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            seatNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showSeatLegend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seat Selection Guide'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem('Available - Tap to select', AppColors.success),
            SizedBox(height: 12),
            _buildLegendItem('Selected - Your choice', AppColors.primary),
            SizedBox(height: 12),
            _buildLegendItem('Occupied - Already booked', AppColors.grey),
            SizedBox(height: 16),
            Text(
              'Tips:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Window seats: A, F', style: TextStyle(fontSize: 12)),
            Text('• Aisle seats: C, D', style: TextStyle(fontSize: 12)),
            Text('• Middle seats: B, E', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _navigateToPassengerDetails() {
    final flightProvider = Provider.of<FlightProvider>(context, listen: false);
    
    // Store selected seat and flight info for booking
    Navigator.pushNamed(
      context,
      AppRoutes.userBookings, // This will be changed to passenger details screen
      arguments: {
        'flightId': widget.flightId,
        'seatNo': _selectedSeat,
        'flight': flightProvider.selectedFlight,
      },
    );
  }
}