import 'package:flutter/material.dart';
import '../../../data/models/seat.dart';
import '../../../core/constants/app_colors.dart';

class SeatSelectionDialog extends StatefulWidget {
  final List<Seat> seats;
  final String? selectedSeat;
  final Function(String)? onSeatSelected;

  const SeatSelectionDialog({
    Key? key,
    required this.seats,
    this.selectedSeat,
    this.onSeatSelected,
  }) : super(key: key);

  @override
  State<SeatSelectionDialog> createState() => _SeatSelectionDialogState();
}

class _SeatSelectionDialogState extends State<SeatSelectionDialog> {
  String? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _selectedSeat = widget.selectedSeat;
  }

  Color _getSeatColor(Seat seat) {
    if (!seat.isAvailable) return AppColors.grey;
    if (_selectedSeat == seat.seatNo) return AppColors.primary;
    if (seat.seatClass == 'BUSINESS') return AppColors.warning;
    if (seat.seatClass == 'FIRST_CLASS') return AppColors.accent;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Your Seat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend('Available', AppColors.success),
                _buildLegend('Selected', AppColors.primary),
                _buildLegend('Occupied', AppColors.grey),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: widget.seats.length,
                itemBuilder: (context, index) {
                  final seat = widget.seats[index];
                  return GestureDetector(
                    onTap: seat.isAvailable
                        ? () => setState(() => _selectedSeat = seat.seatNo)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getSeatColor(seat),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          seat.seatNo,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSeat != null
                    ? () {
                        widget.onSeatSelected?.call(_selectedSeat!);
                        Navigator.pop(context, _selectedSeat);
                      }
                    : null,
                child: Text('Confirm Seat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  static Future<String?> show(
    BuildContext context, {
    required List<Seat> seats,
    String? selectedSeat,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => SeatSelectionDialog(
        seats: seats,
        selectedSeat: selectedSeat,
      ),
    );
  }
}
