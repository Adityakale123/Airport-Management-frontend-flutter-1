import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class AddFlightScreen extends StatefulWidget {
  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _flightNumberController = TextEditingController();
  final _airlineController = TextEditingController();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalSeatsController = TextEditingController();
  final _aircraftTypeController = TextEditingController();
  final _terminalController = TextEditingController();
  final _gateController = TextEditingController();

  DateTime? _departureTime;
  DateTime? _arrivalTime;
  String _status = AppConstants.flightScheduled;
  bool _isLoading = false;

  @override
  void dispose() {
    _flightNumberController.dispose();
    _airlineController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _totalSeatsController.dispose();
    _aircraftTypeController.dispose();
    _terminalController.dispose();
    _gateController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isDeparture) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        setState(() {
          if (isDeparture) {
            _departureTime = dateTime;
          } else {
            _arrivalTime = dateTime;
          }
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_departureTime == null || _arrivalTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select both departure and arrival times')),
      );
      return;
    }

    if (_arrivalTime!.isBefore(_departureTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrival time must be after departure time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final flightData = {
      'number': _flightNumberController.text.trim(),
      'airline': _airlineController.text.trim(),
      'source': _sourceController.text.trim(),
      'destination': _destinationController.text.trim(),
      'departureTime': _departureTime!.toIso8601String(),
      'arrivalTime': _arrivalTime!.toIso8601String(),
      'status': _status,
      'price': double.parse(_priceController.text),
      'totalSeats': int.parse(_totalSeatsController.text),
      'availableSeats': int.parse(_totalSeatsController.text),
      'aircraftType': _aircraftTypeController.text.trim(),
      'terminal': _terminalController.text.trim(),
      'gate': _gateController.text.trim(),
    };

    final provider = Provider.of<FlightProvider>(context, listen: false);
    final success = await provider.createFlight(flightData);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Flight added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to add flight'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Flight'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Flight Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _flightNumberController,
              labelText: 'Flight Number',
              hintText: 'e.g., AI101',
              prefixIcon: Icons.confirmation_number,
              validator: (value) =>
                  Validators.validateRequired(value, 'Flight number'),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _airlineController,
              labelText: 'Airline',
              hintText: 'e.g., Air India',
              prefixIcon: Icons.flight,
              validator: (value) =>
                  Validators.validateRequired(value, 'Airline'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _sourceController,
                    labelText: 'Source',
                    hintText: 'e.g., Mumbai',
                    prefixIcon: Icons.flight_takeoff,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Source'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _destinationController,
                    labelText: 'Destination',
                    hintText: 'e.g., Delhi',
                    prefixIcon: Icons.flight_land,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Destination'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDateTime(true),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _departureTime != null
                                ? DateFormatter.formatDateTime(_departureTime!)
                                : 'Select departure time',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDateTime(false),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arrival Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _arrivalTime != null
                                ? DateFormatter.formatDateTime(_arrivalTime!)
                                : 'Select arrival time',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.info),
                filled: true,
                fillColor: AppColors.greyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                AppConstants.flightScheduled,
                AppConstants.flightBoarding,
                AppConstants.flightDeparted,
                AppConstants.flightArrived,
                AppConstants.flightDelayed,
                AppConstants.flightCancelled,
              ].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _status = value!);
              },
            ),
            SizedBox(height: 24),
            Text(
              'Pricing & Capacity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _priceController,
                    labelText: 'Price (₹)',
                    hintText: 'e.g., 5000',
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.validateNumber(value, 'Price'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _totalSeatsController,
                    labelText: 'Total Seats',
                    hintText: 'e.g., 180',
                    prefixIcon: Icons.event_seat,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.validateNumber(value, 'Total seats'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _aircraftTypeController,
              labelText: 'Aircraft Type',
              hintText: 'e.g., Boeing 737',
              prefixIcon: Icons.airplanemode_active,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _terminalController,
                    labelText: 'Terminal',
                    hintText: 'e.g., Terminal 2',
                    prefixIcon: Icons.business,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _gateController,
                    labelText: 'Gate',
                    hintText: 'e.g., Gate 12',
                    prefixIcon: Icons.meeting_room,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Add Flight',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
              icon: Icons.add,
              width: double.infinity,
              height: 56,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
