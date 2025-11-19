import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/cards/stat_card.dart';

class RevenueAnalyticsScreen extends StatefulWidget {
  @override
  State<RevenueAnalyticsScreen> createState() => _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState extends State<RevenueAnalyticsScreen> {
  String _selectedPeriod = 'Monthly';

  @override
  void initState() {
    super.initState();
    _loadRevenueData();
  }

  Future<void> _loadRevenueData() async {
    await Provider.of<AnalyticsProvider>(context, listen: false)
        .getRevenueAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue Analytics'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadRevenueData,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.download),
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exporting $value report...')),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'PDF', child: Text('Export as PDF')),
              PopupMenuItem(value: 'Excel', child: Text('Export as Excel')),
              PopupMenuItem(value: 'CSV', child: Text('Export as CSV')),
            ],
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading revenue analytics...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text('Failed to load revenue data'),
                  SizedBox(height: 8),
                  Text(provider.errorMessage ?? ''),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadRevenueData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final revenueData = provider.revenueAnalytics ?? {};
          final totalRevenue = (revenueData['totalRevenue'] ?? 0).toDouble();
          final avgTicketPrice =
              (revenueData['avgTicketPrice'] ?? 0).toDouble();

          // Get from overall analytics if revenue analytics doesn't have it
          final analytics = provider.analytics;
          final monthlyRevenue = analytics?.monthlyRevenue ?? 0;
          final yearlyRevenue = analytics?.yearlyRevenue ?? 0;

          return RefreshIndicator(
            onRefresh: _loadRevenueData,
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
                        value: totalRevenue >= 100000
                            ? '₹${(totalRevenue / 100000).toStringAsFixed(1)}L'
                            : '₹${(totalRevenue / 1000).toStringAsFixed(1)}K',
                        icon: Icons.currency_rupee,
                        color: AppColors.success,
                      ),
                      StatCard(
                        title: 'Monthly Revenue',
                        value:
                            '₹${(monthlyRevenue / 1000).toStringAsFixed(0)}K',
                        icon: Icons.calendar_month,
                        color: AppColors.primary,
                      ),
                      StatCard(
                        title: 'Yearly Revenue',
                        value: yearlyRevenue >= 100000
                            ? '₹${(yearlyRevenue / 100000).toStringAsFixed(1)}L'
                            : '₹${(yearlyRevenue / 1000).toStringAsFixed(1)}K',
                        icon: Icons.trending_up,
                        color: AppColors.warning,
                      ),
                      StatCard(
                        title: 'Avg Ticket Price',
                        value: '₹${avgTicketPrice.toStringAsFixed(0)}',
                        icon: Icons.confirmation_number,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revenue Trends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment(value: 'Daily', label: Text('Daily')),
                          ButtonSegment(
                              value: 'Monthly', label: Text('Monthly')),
                          ButtonSegment(value: 'Yearly', label: Text('Yearly')),
                        ],
                        selected: {_selectedPeriod},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => _selectedPeriod = newSelection.first);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Container(
                      height: 250,
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.show_chart,
                                size: 64, color: AppColors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Revenue Chart',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Chart visualization would go here',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Top Routes by Revenue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTopRoutes(revenueData['topRoutesByRevenue']),
                  SizedBox(height: 24),
                  Text(
                    'Revenue by Seat Class',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildRevenueByClass(revenueData['revenueByClass']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopRoutes(dynamic topRoutesData) {
    if (topRoutesData == null ||
        topRoutesData is! List ||
        topRoutesData.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No route data available'),
          ),
        ),
      );
    }

    final routes = topRoutesData as List;

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: routes.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final route = routes[index];
          final routeName = route['route'] ?? 'Unknown Route';
          final revenue = (route['revenue'] ?? 0).toDouble();

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              routeName,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              revenue >= 100000
                  ? '₹${(revenue / 100000).toStringAsFixed(1)}L'
                  : '₹${(revenue / 1000).toStringAsFixed(0)}K',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRevenueByClass(dynamic revenueByClassData) {
    if (revenueByClassData == null ||
        revenueByClassData is! Map ||
        revenueByClassData.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No seat class data available'),
          ),
        ),
      );
    }

    final classData = revenueByClassData as Map<String, dynamic>;
    final totalRevenue = classData.values
        .fold<double>(0, (sum, val) => sum + (val as num).toDouble());

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: classData.entries.map((entry) {
            final className = entry.key;
            final revenue = (entry.value as num).toDouble();
            final percentage =
                totalRevenue > 0 ? (revenue / totalRevenue * 100) : 0;

            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        className.replaceAll('_', ' '),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '₹${(revenue / 1000).toStringAsFixed(1)}K',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            minHeight: 8,
                            backgroundColor: AppColors.greyLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
