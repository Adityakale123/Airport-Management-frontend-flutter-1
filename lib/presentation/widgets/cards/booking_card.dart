import 'package:flutter/material.dart';
import '../../../data/models/booking.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const BookingCard({
    Key? key,
    required this.booking,
    this.onTap,
    this.onCancel,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (booking.status.toUpperCase()) {
      case 'CONFIRMED':
        return AppColors.success;
      case 'CHECKED_IN':
        return AppColors.info;
      case 'BOARDED':
        return AppColors.boarding;
      case 'CANCELLED':
        return AppColors.cancelled;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PNR: ${booking.pnr ?? booking.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (booking.flight != null) ...[
                Row(
                  children: [
                    Icon(Icons.flight, size: 16, color: AppColors.grey),
                    SizedBox(width: 8),
                    Text(
                      '${booking.flight!.number} - ${booking.flight!.source} → ${booking.flight!.destination}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(Icons.event_seat, size: 16, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text('Seat: ${booking.seatNo}',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text(
                    booking.passenger?.name ?? 'Passenger',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormatter.formatDate(booking.bookingDate),
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Text(
                    '₹${booking.amount}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (onCancel != null && booking.status == 'CONFIRMED') ...[
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                    child: Text('Cancel Booking'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
