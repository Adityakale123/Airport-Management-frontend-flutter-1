class Flight {
  final int? id;
  final String flightNumber;  // ✅ Not 'number'
  final String origin;         // ✅ Not 'source'
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int totalSeats;
  final int availableSeats;
  final double economyPrice;
  final double businessPrice;
  final double firstClassPrice;
  final String status;
  final String? aircraftModel;
  final int? terminalId;
  final String? terminalName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Flight({
    this.id,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.economyPrice,
    required this.businessPrice,
    required this.firstClassPrice,
    required this.status,
    this.aircraftModel,
    this.terminalId,
    this.terminalName,
    this.createdAt,
    this.updatedAt,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      flightNumber: json['flightNumber'],
      origin: json['origin'],
      destination: json['destination'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      totalSeats: json['totalSeats'],
      availableSeats: json['availableSeats'],
      economyPrice: json['economyPrice']?.toDouble() ?? 0.0,
      businessPrice: json['businessPrice']?.toDouble() ?? 0.0,
      firstClassPrice: json['firstClassPrice']?.toDouble() ?? 0.0,
      status: json['status'] ?? 'SCHEDULED',
      aircraftModel: json['aircraftModel'],
      terminalId: json['terminalId'],
      terminalName: json['terminalName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightNumber': flightNumber,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'economyPrice': economyPrice,
      'businessPrice': businessPrice,
      'firstClassPrice': firstClassPrice,
      'status': status,
      'aircraftModel': aircraftModel,
      'terminalId': terminalId,
    };
  }

  // Helper getters for backward compatibility if needed
  String get number => flightNumber;
  String get source => origin;
  double get price => economyPrice;
  String? get airline => null; // Remove if not used
  String? get aircraftType => aircraftModel;
  String? get terminal => terminalName;
  String? get gate => null; // Remove if not used
  
  // Duration calculation
  String get duration {
    final difference = arrivalTime.difference(departureTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}