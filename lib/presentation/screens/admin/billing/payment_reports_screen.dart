import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../providers/billing_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class PaymentReportsScreen extends StatefulWidget {
  @override
  State<PaymentReportsScreen> createState() => _PaymentReportsScreenState();
}

class _PaymentReportsScreenState extends State<PaymentReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedReport = 'Summary';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<BillingProvider>(context, listen: false);
    await provider.getBillingData();
    await provider.getPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generating report...')),
              );
            },
          ),
        ],
      ),
      body: Consumer<BillingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading payment reports...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text('Failed to load payment data'),
                  SizedBox(height: 8),
                  Text(provider.errorMessage ?? ''),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Period',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateSelector(
                                'Start Date',
                                _startDate,
                                () => _selectDate(true),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildDateSelector(
                                'End Date',
                                _endDate,
                                () => _selectDate(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'Summary', label: Text('Summary')),
                    ButtonSegment(value: 'Detailed', label: Text('Detailed')),
                    ButtonSegment(value: 'Failed', label: Text('Failed')),
                  ],
                  selected: {_selectedReport},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _selectedReport = newSelection.first);
                  },
                ),
                SizedBox(height: 24),
                if (_selectedReport == 'Summary') _buildSummaryReport(provider),
                if (_selectedReport == 'Detailed')
                  _buildDetailedReport(provider),
                if (_selectedReport == 'Failed') _buildFailedReport(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              date != null ? DateFormatter.formatDate(date) : 'Select date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildSummaryReport(BillingProvider provider) {
    final billingData = provider.billingData;
    final payments = provider.payments ?? [];

    final totalPayments = payments.length;
    final successfulPayments =
        payments.where((p) => p.status == 'CONFIRMED').length;
    final failedPayments = payments.where((p) => p.status == 'FAILED').length;
    final totalAmount = payments
        .where((p) => p.status == 'CONFIRMED')
        .fold<double>(0, (sum, p) => sum + p.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildSummaryCard(
            'Total Payments', totalPayments.toString(), AppColors.primary),
        SizedBox(height: 12),
        _buildSummaryCard(
            'Successful', successfulPayments.toString(), AppColors.success),
        SizedBox(height: 12),
        _buildSummaryCard('Failed', failedPayments.toString(), AppColors.error),
        SizedBox(height: 12),
        _buildSummaryCard('Total Amount', '₹${totalAmount.toStringAsFixed(2)}',
            AppColors.warning),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReport(BillingProvider provider) {
    final payments = provider.payments ?? [];

    if (payments.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No payment data available')),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: payments.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final payment = payments[index];
              final isSuccess = payment.status == 'CONFIRMED';

              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isSuccess ? AppColors.success : AppColors.error)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    color: isSuccess ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                ),
                title: Text(payment.id),
                subtitle: Text(
                  '${payment.method} • ${DateFormatter.formatDate(payment.date)}',
                ),
                trailing: Text(
                  '₹${payment.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFailedReport(BillingProvider provider) {
    final payments = provider.payments ?? [];
    final failedPayments = payments.where((p) => p.status == 'FAILED').toList();

    if (failedPayments.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No failed payments')),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Failed Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: failedPayments.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final payment = failedPayments[index];

              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.error, color: AppColors.error, size: 20),
                ),
                title: Text(payment.id),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${payment.method} • ${DateFormatter.formatDate(payment.date)}',
                    ),
                    if (payment.reason != null) ...[
                      SizedBox(height: 4),
                      Text(
                        payment.reason!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Text(
                  '₹${payment.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Options'),
        content: Text('Filter options will be added here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
