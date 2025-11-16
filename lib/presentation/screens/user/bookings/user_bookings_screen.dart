import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/booking_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/cards/booking_card.dart';
import '../../../widgets/dialogs/confirmation_dialog.dart';

class UserBookingsScreen extends StatefulWidget {
  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Delay loading to avoid setState during build
    Future.microtask(() => _loadBookings());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    await Provider.of<BookingProvider>(context, listen: false)
        .getUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading bookings...');
          }

          if (provider.bookings.isEmpty) {
            return EmptyState(
              icon: Icons.confirmation_number,
              title: 'No Bookings Yet',
              subtitle: 'Book your first flight to get started',
              actionText: 'Search Flights',
              onActionPressed: () {
                Navigator.pushNamed(context, AppRoutes.flightSearch);
              },
            );
          }

          return Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(provider.bookings
                      .where((b) =>
                          b.status == 'PENDING' ||
                          b.status == 'CONFIRMED' ||
                          b.status == 'CHECKED_IN')
                      .toList()),
                  _buildBookingsList(provider.bookings
                      .where((b) => b.status == 'BOARDED')
                      .toList()),
                  _buildBookingsList(provider.bookings
                      .where((b) => b.status == 'CANCELLED')
                      .toList()),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.flightSearch);
                  },
                  icon: Icon(Icons.add),
                  label: Text('Book Flight'),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingsList(List bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: AppColors.grey),
            SizedBox(height: 16),
            Text('No bookings in this category'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            booking: booking,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.bookingDetails,
                arguments: booking.id,
              );
            },
            onCancel: booking.status == 'CONFIRMED'
                ? () => _handleCancelBooking(booking.id!)
                : null,
          );
        },
      ),
    );
  }

  Future<void> _handleCancelBooking(int bookingId) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Cancel Booking',
      message: 'Are you sure you want to cancel this booking?',
      confirmText: 'Cancel Booking',
      isDanger: true,
    );

    if (confirmed == true) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      final success = await provider.cancelBooking(bookingId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to cancel booking'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
