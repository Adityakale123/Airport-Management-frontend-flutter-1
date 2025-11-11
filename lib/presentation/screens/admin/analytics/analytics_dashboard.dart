import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/cards/stat_card.dart';

class AnalyticsDashboard extends StatefulWidget {
  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    await Provider.of<AnalyticsProvider>(context, listen: false).refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
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
            return LoadingIndicator(message: 'Loading analytics...');
          }

          final analytics = provider.analytics;

          return RefreshIndicator(
            onRefresh: _loadAnalytics,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      StatCard(
                        title: 'Total Flights',
                        value: analytics?.totalFlights.toString() ?? '0',
                        icon: Icons.flight_takeoff,
                        color: AppColors.primary,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.adminFlightAnalytics,
                        ),
                      ),
                      StatCard(
                        title: 'Total Bookings',
                        value: analytics?.totalBookings.toString() ?? '0',
                        icon: Icons.confirmation_number,
                        color: AppColors.secondary,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.adminBookingAnalytics,
                        ),
                      ),
                      StatCard(
                        title: 'Total Passengers',
                        value: analytics?.totalPassengers.toString() ?? '0',
                        icon: Icons.people,
                        color: AppColors.warning,
                      ),
                      StatCard(
                        title: 'Total Staff',
                        value: analytics?.totalStaff.toString() ?? '0',
                        icon: Icons.badge,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Revenue Analytics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Revenue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Icon(Icons.trending_up, color: AppColors.success),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹${analytics?.totalRevenue.toStringAsFixed(2) ?? '0'}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildRevenueItem(
                                'Monthly',
                                '₹${analytics?.monthlyRevenue.toStringAsFixed(2) ?? '0'}',
                              ),
                              Container(
                                  width: 1,
                                  height: 50,
                                  color: AppColors.greyLight),
                              _buildRevenueItem(
                                'Yearly',
                                '₹${analytics?.yearlyRevenue.toStringAsFixed(2) ?? '0'}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          'Flight Analytics',
                          Icons.flight,
                          AppColors.primary,
                          () => Navigator.pushNamed(
                            context,
                            AppRoutes.adminFlightAnalytics,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          'Booking Analytics',
                          Icons.analytics,
                          AppColors.secondary,
                          () => Navigator.pushNamed(
                            context,
                            AppRoutes.adminBookingAnalytics,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRevenueItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
