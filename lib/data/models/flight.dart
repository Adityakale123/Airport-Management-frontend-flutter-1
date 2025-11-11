class Flight {
  final int? id;
  final String number;
  final String airline;
  final String source;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String status;
  final double price;
  final int totalSeats;
  final int availableSeats;
  final String? aircraftType;
  final String? terminal;
  final String? gate;

  Flight({
    this.id,
    required this.number,
    required this.airline,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    this.aircraftType,
    this.terminal,
    this.gate,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      number: json['number'] ?? '',
      airline: json['airline'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.parse(json['departureTime'] ?? json['time']),
      arrivalTime: DateTime.parse(json['arrivalTime'] ?? json['time']),
      status: json['status'] ?? 'SCHEDULED',
      price: (json['price'] ?? 0).toDouble(),
      totalSeats: json['totalSeats'] ?? 0,
      availableSeats: json['availableSeats'] ?? 0,
      aircraftType: json['aircraftType'],
      terminal: json['terminal'],
      gate: json['gate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'airline': airline,
      'source': source,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'status': status,
      'price': price,
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'aircraftType': aircraftType,
      'terminal': terminal,
      'gate': gate,
    };
  }

  String get duration {
    final diff = arrivalTime.difference(departureTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
