import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/billing_provider.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/cards/stat_card.dart';
import '../../../widgets/common/loading_indicator.dart';

class BillingDashboard extends StatefulWidget {
  @override
  State<BillingDashboard> createState() => _BillingDashboardState();
}

class _BillingDashboardState extends State<BillingDashboard> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<AnalyticsProvider>(context, listen: false).getAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading billing data...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text('Failed to load billing data'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final analytics = provider.analytics;

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue Overview',
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
                        title: 'Total Revenue',
                        value:
                            '₹${((analytics?.totalRevenue ?? 0) / 1000).toStringAsFixed(0)}K',
                        icon: Icons.currency_rupee,
                        color: AppColors.success,
                      ),
                      StatCard(
                        title: 'Monthly Revenue',
                        value:
                            '₹${((analytics?.monthlyRevenue ?? 0) / 1000).toStringAsFixed(0)}K',
                        icon: Icons.trending_up,
                        color: AppColors.primary,
                      ),
                      StatCard(
                        title: 'Total Bookings',
                        value: analytics?.totalBookings.toString() ?? '0',
                        icon: Icons.receipt_long,
                        color: AppColors.warning,
                      ),
                      StatCard(
                        title: 'Total Flights',
                        value: analytics?.totalFlights.toString() ?? '0',
                        icon: Icons.flight_takeoff,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildQuickActionCard(
                    'Revenue Analytics',
                    Icons.analytics,
                    AppColors.primary,
                    () => Navigator.pushNamed(context, AppRoutes.adminRevenue),
                  ),
                  SizedBox(height: 12),
                  _buildQuickActionCard(
                    'Payment Reports',
                    Icons.assessment,
                    AppColors.secondary,
                    () => Navigator.pushNamed(
                        context, AppRoutes.adminPaymentReports),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
