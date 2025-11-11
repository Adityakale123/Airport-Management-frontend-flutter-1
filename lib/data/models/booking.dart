class Booking {
  final int? id;
  final int userId;
  final int flightId;
  final int passengerId;
  final String seatNo;
  final String status;
  final double amount;
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
    required this.seatNo,
    required this.status,
    required this.amount,
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
      seatNo: json['seatNo'] ?? '',
      status: json['status'] ?? 'CONFIRMED',
      amount: (json['amount'] ?? 0).toDouble(),
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
      'seatNo': seatNo,
      'status': status,
      'amount': amount,
      'bookingDate': bookingDate.toIso8601String(),
      'pnr': pnr,
    };
  }
}
