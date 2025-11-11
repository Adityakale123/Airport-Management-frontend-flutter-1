import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: Text('Available Flights'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
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
            padding: EdgeInsets.symmetric(vertical: 8),
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
