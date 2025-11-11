import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../widgets/cards/stat_card.dart';

class BillingDashboard extends StatefulWidget {
  @override
  State<BillingDashboard> createState() => _BillingDashboardState();
}

class _BillingDashboardState extends State<BillingDashboard> {
  // Mock data
  final double _totalRevenue = 2450000;
  final double _monthlyRevenue = 450000;
  final int _totalInvoices = 1250;
  final int _pendingPayments = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refreshing billing data...')),
              );
            },
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
                  value: '₹${(_totalRevenue / 1000).toStringAsFixed(0)}K',
                  icon: Icons.currency_rupee,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Monthly Revenue',
                  value: '₹${(_monthlyRevenue / 1000).toStringAsFixed(0)}K',
                  icon: Icons.trending_up,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Total Invoices',
                  value: _totalInvoices.toString(),
                  icon: Icons.receipt_long,
                  color: AppColors.warning,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.adminInvoices,
                  ),
                ),
                StatCard(
                  title: 'Pending Payments',
                  value: _pendingPayments.toString(),
                  icon: Icons.pending_actions,
                  color: AppColors.error,
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
              'View All Invoices',
              Icons.receipt_long,
              AppColors.primary,
              () => Navigator.pushNamed(context, AppRoutes.adminInvoices),
            ),
            SizedBox(height: 12),
            _buildQuickActionCard(
              'Revenue Analytics',
              Icons.analytics,
              AppColors.secondary,
              () => Navigator.pushNamed(context, AppRoutes.adminRevenue),
            ),
            SizedBox(height: 12),
            _buildQuickActionCard(
              'Payment Reports',
              Icons.assessment,
              AppColors.warning,
              () => Navigator.pushNamed(context, AppRoutes.adminPaymentReports),
            ),
            SizedBox(height: 24),
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildRecentTransactions(),
          ],
        ),
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

  Widget _buildRecentTransactions() {
    final transactions = [
      {
        'id': 'TXN001',
        'amount': 5000.0,
        'status': 'COMPLETED',
        'date': 'Today',
      },
      {
        'id': 'TXN002',
        'amount': 3500.0,
        'status': 'PENDING',
        'date': 'Yesterday',
      },
      {
        'id': 'TXN003',
        'amount': 7200.0,
        'status': 'COMPLETED',
        'date': '2 days ago',
      },
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final txn = transactions[index];
          final isCompleted = txn['status'] == 'COMPLETED';

          return ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isCompleted ? AppColors.success : AppColors.warning)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.pending,
                color: isCompleted ? AppColors.success : AppColors.warning,
              ),
            ),
            title: Text(txn['id'] as String),
            subtitle: Text(txn['date'] as String),
            trailing: Text(
              '₹${txn['amount']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
