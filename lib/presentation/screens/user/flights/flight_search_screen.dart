import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class FlightSearchScreen extends StatefulWidget {
  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _departureDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() => _departureDate = picked);
    }
  }

  Future<void> _handleSearch() async {
    if (!_formKey.currentState!.validate()) return;
    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select departure date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final searchParams = {
      'source': _sourceController.text.trim(),
      'destination': _destinationController.text.trim(),
      'date': DateFormatter.formatApiDate(_departureDate!),
    };

    await Provider.of<FlightProvider>(context, listen: false)
        .searchFlights(searchParams);

    setState(() => _isLoading = false);

    Navigator.pushNamed(context, AppRoutes.flightList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Flights')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.flight_takeoff, size: 48, color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Find Your Flight',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        controller: _sourceController,
                        labelText: 'From',
                        hintText: 'Enter departure city',
                        prefixIcon: Icons.flight_takeoff,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      SizedBox(height: 16),
                      CustomTextField(
                        controller: _destinationController,
                        labelText: 'To',
                        hintText: 'Enter destination city',
                        prefixIcon: Icons.flight_land,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.grey),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _departureDate == null
                                      ? 'Select departure date'
                                      : DateFormatter.formatDate(_departureDate!),
                                  style: TextStyle(
                                    color: _departureDate == null
                                        ? AppColors.grey
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        text: 'Search Flights',
                        onPressed: _handleSearch,
                        isLoading: _isLoading,
                        width: double.infinity,
                        icon: Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Popular Routes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _buildPopularRoute('Mumbai', 'Delhi'),
              _buildPopularRoute('Bangalore', 'Mumbai'),
              _buildPopularRoute('Delhi', 'Goa'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularRoute(String from, String to) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.trending_up, color: AppColors.primary),
        title: Text('$from → $to'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _sourceController.text = from;
          _destinationController.text = to;
        },
      ),
    );
  }
}