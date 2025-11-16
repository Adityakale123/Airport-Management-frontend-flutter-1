import 'flight.dart';
import 'passenger.dart';

class Booking {
  final int? id;
  final int userId;
  final int flightId;
  final int passengerId;
  final String seatNumber; // Changed from seatNo to match backend
  final String seatClass; // Added from backend
  final String status;
  final double price; // Changed from amount to match backend
  final String paymentStatus; // Added from backend
  final DateTime bookingDate;
  final String? pnr;
  final String? qrCode;

  // Populated fields
  final Flight? flight;
  final Passenger? passenger;

  Booking({
    this.id,
    required this.userId,
    required this.flightId,
    required this.passengerId,
    required this.seatNumber,
    required this.seatClass,
    required this.status,
    required this.price,
    required this.paymentStatus,
    required this.bookingDate,
    this.pnr,
    this.qrCode,
    this.flight,
    this.passenger,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'] ?? 0,
      flightId: json['flightId'] ?? 0,
      passengerId: json['passengerId'] ?? 0,
      seatNumber: json['seatNumber'] ?? json['seatNo'] ?? '',
      seatClass: json['seatClass'] ?? 'ECONOMY',
      status: json['status'] ?? 'CONFIRMED',
      price: (json['price'] ?? json['amount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      bookingDate: DateTime.parse(
        json['bookingDate'] ?? DateTime.now().toIso8601String(),
      ),
      pnr: json['pnr'],
      qrCode: json['qrCode'],
      flight: json['flight'] != null ? Flight.fromJson(json['flight']) : null,
      passenger: json['passenger'] != null
          ? Passenger.fromJson(json['passenger'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'flightId': flightId,
      'passengerId': passengerId,
      'seatNumber': seatNumber,
      'seatClass': seatClass,
      'status': status,
      'price': price,
      'paymentStatus': paymentStatus,
      'bookingDate': bookingDate.toIso8601String(),
      'pnr': pnr,
    };
  }
}
