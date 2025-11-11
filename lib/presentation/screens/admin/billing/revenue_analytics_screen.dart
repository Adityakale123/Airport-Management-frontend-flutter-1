import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/cards/stat_card.dart';

class RevenueAnalyticsScreen extends StatefulWidget {
  @override
  State<RevenueAnalyticsScreen> createState() => _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState extends State<RevenueAnalyticsScreen> {
  String _selectedPeriod = 'Monthly';

  // Mock data
  final double _totalRevenue = 2450000;
  final double _monthlyRevenue = 450000;
  final double _yearlyRevenue = 5400000;
  final double _avgTicketPrice = 3500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue Analytics'),
        actions: [
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
      body: SingleChildScrollView(
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
                  value: '₹${(_totalRevenue / 100000).toStringAsFixed(1)}L',
                  icon: Icons.currency_rupee,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Monthly Revenue',
                  value: '₹${(_monthlyRevenue / 1000).toStringAsFixed(0)}K',
                  icon: Icons.calendar_month,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Yearly Revenue',
                  value: '₹${(_yearlyRevenue / 100000).toStringAsFixed(1)}L',
                  icon: Icons.trending_up,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'Avg Ticket Price',
                  value: '₹${_avgTicketPrice.toStringAsFixed(0)}',
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
                    ButtonSegment(value: 'Monthly', label: Text('Monthly')),
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
                      Icon(Icons.show_chart, size: 64, color: AppColors.grey),
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
            _buildTopRoutes(),
            SizedBox(height: 24),
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildPaymentMethods(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRoutes() {
    final routes = [
      {'route': 'Mumbai → Delhi', 'revenue': 850000, 'bookings': 245},
      {'route': 'Bangalore → Mumbai', 'revenue': 720000, 'bookings': 198},
      {'route': 'Delhi → Goa', 'revenue': 650000, 'bookings': 176},
      {'route': 'Mumbai → Bangalore', 'revenue': 580000, 'bookings': 152},
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: routes.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final route = routes[index];
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
              route['route'] as String,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${route['bookings']} bookings'),
            trailing: Text(
              '₹${(route['revenue'] as int) / 1000}K',
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

  Widget _buildPaymentMethods() {
    final methods = [
      {'method': 'Credit/Debit Card', 'percentage': 45, 'amount': 1102500},
      {'method': 'UPI', 'percentage': 30, 'amount': 735000},
      {'method': 'Net Banking', 'percentage': 20, 'amount': 490000},
      {'method': 'Wallet', 'percentage': 5, 'amount': 122500},
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: methods.map((method) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        method['method'] as String,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '₹${(method['amount'] as int) / 1000}K',
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
                            value: (method['percentage'] as int) / 100,
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
                        '${method['percentage']}%',
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
