class Seat {
  final String seatNo;
  final String seatClass;
  final bool isAvailable;
  final bool isWindow;
  final bool isAisle;
  final double price;

  Seat({
    required this.seatNo,
    required this.seatClass,
    required this.isAvailable,
    required this.isWindow,
    required this.isAisle,
    required this.price,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNo: json['seatNo'] ?? '',
      seatClass: json['seatClass'] ?? 'ECONOMY',
      isAvailable: json['isAvailable'] ?? true,
      isWindow: json['isWindow'] ?? false,
      isAisle: json['isAisle'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatNo': seatNo,
      'seatClass': seatClass,
      'isAvailable': isAvailable,
      'isWindow': isWindow,
      'isAisle': isAisle,
      'price': price,
    };
  }
}
