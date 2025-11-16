import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/cards/flight_card.dart';
import '../../../widgets/dialogs/confirmation_dialog.dart';

class FlightsManagementScreen extends StatefulWidget {
  @override
  State<FlightsManagementScreen> createState() =>
      _FlightsManagementScreenState();
}

class _FlightsManagementScreenState extends State<FlightsManagementScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    await Provider.of<FlightProvider>(context, listen: false).getAdminFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFlights,
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search flights...',
            onChanged: (value) {
              setState(() => _searchQuery = value.toLowerCase());
            },
          ),
          Expanded(
            child: Consumer<FlightProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return LoadingIndicator(message: 'Loading flights...');
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: AppColors.error),
                        SizedBox(height: 16),
                        Text(provider.errorMessage!),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadFlights,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final flights = provider.flights.where((flight) {
                  final query = _searchQuery;
                  // ✅ UPDATED - Use correct field names
                  return flight.flightNumber.toLowerCase().contains(query) ||
                      flight.origin.toLowerCase().contains(query) ||
                      flight.destination.toLowerCase().contains(query);
                }).toList();

                if (flights.isEmpty) {
                  return EmptyState(
                    icon: Icons.flight_takeoff,
                    title: 'No Flights Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'Add your first flight to get started'
                        : 'No flights match your search',
                    actionText: 'Add Flight',
                    onActionPressed: () {
                      Navigator.pushNamed(context, AppRoutes.adminAddFlight);
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadFlights,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      return FlightCard(
                        flight: flight,
                        showActions: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.adminFlightDetails,
                            arguments: flight.id,
                          );
                        },
                        onEdit: () => _handleEditFlight(flight.id!),
                        onDelete: () => _handleDeleteFlight(flight.id!),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adminAddFlight);
        },
        icon: Icon(Icons.add),
        label: Text('Add Flight'),
      ),
    );
  }

  void _handleEditFlight(int flightId) {
    // Navigate to edit screen (can use add screen with flightId)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit functionality - Flight ID: $flightId')),
    );
  }

  Future<void> _handleDeleteFlight(int flightId) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Flight',
      message: 'Are you sure you want to delete this flight?',
      confirmText: 'Delete',
      isDanger: true,
    );

    if (confirmed == true) {
      final provider = Provider.of<FlightProvider>(context, listen: false);
      final success = await provider.deleteFlight(flightId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Flight deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to delete flight'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}