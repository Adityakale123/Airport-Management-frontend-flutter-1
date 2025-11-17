import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/analytics_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import 'package:intl/intl.dart';

class BookingAnalyticsScreen extends StatefulWidget {
  @override
  State<BookingAnalyticsScreen> createState() => _BookingAnalyticsScreenState();
}

class _BookingAnalyticsScreenState extends State<BookingAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    await Provider.of<AnalyticsProvider>(context, listen: false)
        .getBookingAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Analytics'),
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
            return LoadingIndicator(message: 'Loading booking analytics...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text('Failed to load booking analytics'),
                  SizedBox(height: 8),
                  Text(
                    provider.errorMessage ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAnalytics,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final bookingData = provider.bookingAnalytics ?? {};
          final totalBookings = (bookingData['totalBookings'] ?? 0);
          final confirmedBookings = (bookingData['confirmedBookings'] ?? 0);
          final pendingBookings = (bookingData['pendingBookings'] ?? 0);
          final cancelledBookings = (bookingData['cancelledBookings'] ?? 0);
          final dailyTrends =
              bookingData['dailyTrends'] as Map<String, dynamic>? ?? {};

          return RefreshIndicator(
            onRefresh: _loadAnalytics,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Statistics',
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
                      _buildStatCard(
                        'Total',
                        totalBookings.toString(),
                        AppColors.primary,
                      ),
                      _buildStatCard(
                        'Confirmed',
                        confirmedBookings.toString(),
                        AppColors.success,
                      ),
                      _buildStatCard(
                        'Pending',
                        pendingBookings.toString(),
                        AppColors.warning,
                      ),
                      _buildStatCard(
                        'Cancelled',
                        cancelledBookings.toString(),
                        AppColors.error,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Booking Trends',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTrendsCard(dailyTrends),
                  SizedBox(height: 24),
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSummaryCard(
                    totalBookings,
                    confirmedBookings,
                    pendingBookings,
                    cancelledBookings,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsCard(Map<String, dynamic> dailyTrends) {
    if (dailyTrends.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.trending_up, size: 48, color: AppColors.grey),
                SizedBox(height: 16),
                Text(
                  'No booking trends available',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sort dates and get last 7 days
    final sortedEntries = dailyTrends.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Get the max value for scaling
    final maxBookings = sortedEntries.isEmpty
        ? 100.0
        : sortedEntries
            .map((e) => (e.value as num).toDouble())
            .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 7 Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ...sortedEntries.map((entry) {
              final date = DateTime.parse(entry.key);
              final bookings = (entry.value as num).toInt();
              final dayName = DateFormat('EEE').format(date);

              return _buildTrendRow(
                dayName,
                bookings,
                maxBookings > 0 ? maxBookings : 100,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendRow(String day, int bookings, double maxBookings) {
    final percentage = maxBookings > 0 ? (bookings / maxBookings) : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Text(
            bookings.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    int total,
    int confirmed,
    int pending,
    int cancelled,
  ) {
    final confirmedPercent =
        total > 0 ? (confirmed / total * 100).toStringAsFixed(1) : '0';
    final pendingPercent =
        total > 0 ? (pending / total * 100).toStringAsFixed(1) : '0';
    final cancelledPercent =
        total > 0 ? (cancelled / total * 100).toStringAsFixed(1) : '0';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Status Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            _buildPercentageRow(
              'Confirmed',
              confirmedPercent,
              AppColors.success,
            ),
            SizedBox(height: 16),
            _buildPercentageRow(
              'Pending',
              pendingPercent,
              AppColors.warning,
            ),
            SizedBox(height: 16),
            _buildPercentageRow(
              'Cancelled',
              cancelledPercent,
              AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageRow(String label, String percentage, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
