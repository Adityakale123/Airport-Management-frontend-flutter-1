import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class FlightAnalyticsScreen extends StatefulWidget {
  @override
  State<FlightAnalyticsScreen> createState() => _FlightAnalyticsScreenState();
}

class _FlightAnalyticsScreenState extends State<FlightAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    await Provider.of<AnalyticsProvider>(context, listen: false)
        .getFlightAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Analytics'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading flight analytics...');
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flight Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildStatCard(
                  'Total Flights',
                  '156',
                  Icons.flight_takeoff,
                  AppColors.primary,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'On-Time Flights',
                  '142',
                  Icons.check_circle,
                  AppColors.success,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'Delayed Flights',
                  '12',
                  Icons.schedule,
                  AppColors.warning,
                ),
                SizedBox(height: 12),
                _buildStatCard(
                  'Cancelled Flights',
                  '2',
                  Icons.cancel,
                  AppColors.error,
                ),
                SizedBox(height: 24),
                Text(
                  'Popular Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildRouteCard('Mumbai → Delhi', 45, AppColors.primary),
                _buildRouteCard('Bangalore → Mumbai', 38, AppColors.secondary),
                _buildRouteCard('Delhi → Goa', 32, AppColors.accent),
                SizedBox(height: 24),
                Text(
                  'Flight Performance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPerformanceRow(
                            'On-Time Rate', '91%', AppColors.success),
                        Divider(height: 24),
                        _buildPerformanceRow(
                            'Average Delay', '15 min', AppColors.warning),
                        Divider(height: 24),
                        _buildPerformanceRow(
                            'Cancellation Rate', '1.3%', AppColors.error),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(String route, int count, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.trending_up, color: color),
        title: Text(route, style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          '$count flights',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
