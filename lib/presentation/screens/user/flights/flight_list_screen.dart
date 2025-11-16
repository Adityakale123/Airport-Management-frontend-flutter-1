import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/flight_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/cards/flight_card.dart';

class FlightListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Flights'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog
            },
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Searching flights...');
          }

          // Check for error message
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  const Text(
                    'Error searching flights',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      provider.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (provider.searchResults.isEmpty) {
            return EmptyState(
              icon: Icons.flight,
              title: 'No flights found',
              subtitle: 'Try adjusting your search criteria',
              actionText: 'Search Again',
              onActionPressed: () => Navigator.pop(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final flight = provider.searchResults[index];
              return FlightCard(
                flight: flight,
                onTap: () {
                  provider.selectFlight(flight);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.flightDetails,
                    arguments: flight.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
