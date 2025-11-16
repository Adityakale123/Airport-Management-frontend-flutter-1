import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/flight_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/custom_button.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int flightId;

  const SeatSelectionScreen({Key? key, required this.flightId})
      : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? _selectedSeat;
  String _selectedSeatClass = 'ECONOMY';
  List<String> _occupiedSeats = [];
  bool _isLoadingSeats = true;

  final int _rows = 20;
  final List<String> _columns = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  void initState() {
    super.initState();
    _loadOccupiedSeats();
  }

Future<void> _loadOccupiedSeats() async {
    setState(() {
      _isLoadingSeats = true;
    });

    try {
      final bookingProvider = context.read<BookingProvider>();
      
     
      final occupiedSeats = await bookingProvider.getOccupiedSeatsForFlight(widget.flightId);
      
      setState(() {
        _occupiedSeats = occupiedSeats;
        _isLoadingSeats = false;
      });

      print('Loaded ${_occupiedSeats.length} occupied seats for flight ${widget.flightId}');
      print('Occupied seats: $_occupiedSeats');
    } catch (e) {
      print(' Error loading seats: $e');
      setState(() {
        _isLoadingSeats = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load seat availability'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  double _getPrice() {
    final flight =
        Provider.of<FlightProvider>(context, listen: false).selectedFlight;
    if (flight == null) return 0.0;

    switch (_selectedSeatClass) {
      case 'ECONOMY':
        return flight.economyPrice;
      case 'BUSINESS':
        return flight.businessPrice;
      case 'FIRST_CLASS':
        return flight.firstClassPrice;
      default:
        return flight.economyPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Seat'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOccupiedSeats, 
            tooltip: 'Refresh seats',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showSeatLegend,
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.selectedFlight == null) {
            return LoadingIndicator();
          }

         
          if (_isLoadingSeats) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Loading seat availability...'),
                ],
              ),
            );
          }

          final flight = provider.selectedFlight!;

          return Column(
            children: [
              
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
                    
                    SizedBox(height: 4),
                    Text(
                      '${_occupiedSeats.length} seats booked',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

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

            
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Seat Class:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSeatClassButton('ECONOMY', 'Economy'),
                        SizedBox(width: 8),
                        _buildSeatClassButton('BUSINESS', 'Business'),
                        SizedBox(width: 8),
                        _buildSeatClassButton('FIRST_CLASS', 'First Class'),
                      ],
                    ),
                  ],
                ),
              ),

        
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        
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
                            child: Icon(Icons.flight_takeoff,
                                color: AppColors.primary),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Seat:',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _selectedSeat!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${_getPrice().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
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
      onTap: isOccupied
          ? null
          : () {
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

  Widget _buildSeatClassButton(String classCode, String label) {
    final isSelected = _selectedSeatClass == classCode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSeatClass = classCode;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
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

  void _navigateToPassengerDetails() async {
    if (_selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a seat')),
      );
      return;
    }

    if (_occupiedSeats.contains(_selectedSeat)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seat $_selectedSeat is no longer available'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _selectedSeat = null;
      });
      return;
    }

    _showLoadingDialog(context);

    try {
      final authProvider = context.read<AuthProvider>();
      final bookingProvider = context.read<BookingProvider>();

      final user = authProvider.user;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final bookingData = {
        'flightId': widget.flightId,
        'userId': user.id ?? 0,
        'passengerId': user.id ?? 0,
        'seatNumber': _selectedSeat,
        'seatClass': _selectedSeatClass,
        'status': 'PENDING',
        'price': _getPrice(),
        'paymentStatus': 'PENDING',
      };

      final booking = await bookingProvider.createBooking(bookingData);

      if (mounted) {
        Navigator.pop(context);

        if (booking != null && booking.id != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.payment,
            arguments: booking.id,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create booking'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Creating your booking...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
