import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class AddFlightScreen extends StatefulWidget {
  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  late TextEditingController _flightNumberController;
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;
  late TextEditingController _totalSeatsController;
  late TextEditingController _economyPriceController;
  late TextEditingController _businessPriceController;
  late TextEditingController _firstClassPriceController;
  late TextEditingController _aircraftModelController;
  late TextEditingController _terminalIdController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _flightNumberController = TextEditingController();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();
    _totalSeatsController = TextEditingController();
    _economyPriceController = TextEditingController();
    _businessPriceController = TextEditingController();
    _firstClassPriceController = TextEditingController();
    _aircraftModelController = TextEditingController();
    _terminalIdController = TextEditingController();
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _totalSeatsController.dispose();
    _economyPriceController.dispose();
    _businessPriceController.dispose();
    _firstClassPriceController.dispose();
    _aircraftModelController.dispose();
    _terminalIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDepartureDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _departureTimeController.text =
            dateTime.toIso8601String().split('.')[0];
      }
    }
  }

  Future<void> _selectArrivalDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 2) % 24),
      );

      if (time != null) {
        final dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _arrivalTimeController.text = dateTime.toIso8601String().split('.')[0];
      }
    }
  }

  Future<void> _addFlight() async {
    if (_flightNumberController.text.isEmpty ||
        _originController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _departureTimeController.text.isEmpty ||
        _arrivalTimeController.text.isEmpty ||
        _totalSeatsController.text.isEmpty ||
        _economyPriceController.text.isEmpty ||
        _businessPriceController.text.isEmpty ||
        _firstClassPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final flightData = {
        'flightNumber': _flightNumberController.text,
        'origin': _originController.text,
        'destination': _destinationController.text,
        'departureTime': _departureTimeController.text,
        'arrivalTime': _arrivalTimeController.text,
        'totalSeats': int.parse(_totalSeatsController.text),
        'economyPrice': double.parse(_economyPriceController.text),
        'businessPrice': double.parse(_businessPriceController.text),
        'firstClassPrice': double.parse(_firstClassPriceController.text),
        if (_aircraftModelController.text.isNotEmpty)
          'aircraftModel': _aircraftModelController.text,
        if (_terminalIdController.text.isNotEmpty)
          'terminalId': int.parse(_terminalIdController.text),
        'status': 'SCHEDULED',
      };

      final success = await Provider.of<FlightProvider>(context, listen: false)
          .createFlight(flightData);

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flight added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add flight')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Flight'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Required Fields Section
            const Text(
              'Flight Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _flightNumberController,
              labelText: 'Flight Number *',
              hintText: 'e.g., AI101',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _originController,
              labelText: 'Origin Airport *',
              hintText: 'e.g., Delhi (DEL)',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _destinationController,
              labelText: 'Destination Airport *',
              hintText: 'e.g., Mumbai (BOM)',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDepartureDateTime,
              child: CustomTextField(
                controller: _departureTimeController,
                labelText: 'Departure Time *',
                hintText: 'YYYY-MM-DDTHH:mm:ss',
                enabled: false,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectArrivalDateTime,
              child: CustomTextField(
                controller: _arrivalTimeController,
                labelText: 'Arrival Time *',
                hintText: 'YYYY-MM-DDTHH:mm:ss',
                enabled: false,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Seat & Pricing Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _totalSeatsController,
              labelText: 'Total Seats *',
              hintText: 'e.g., 180',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _economyPriceController,
              labelText: 'Economy Price (₹) *',
              hintText: 'e.g., 3000',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _businessPriceController,
              labelText: 'Business Price (₹) *',
              hintText: 'e.g., 6000',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _firstClassPriceController,
              labelText: 'First Class Price (₹) *',
              hintText: 'e.g., 10000',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Optional Fields Section
            const Text(
              'Additional Information (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _aircraftModelController,
              labelText: 'Aircraft Model',
              hintText: 'e.g., Boeing 737',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _terminalIdController,
              labelText: 'Terminal ID',
              hintText: 'e.g., 1',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Submit Button
            CustomButton(
              text: _isLoading ? 'Adding...' : 'Add Flight',
              onPressed: _isLoading ? () {} : _addFlight,
              width: double.infinity,
              height: 56,
            ),
            const SizedBox(height: 16),
            Text(
              '* Required fields',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
