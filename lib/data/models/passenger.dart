class Passenger {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? passportNumber;
  final String? nationality;
  final DateTime? dateOfBirth;
  final String? gender;

  Passenger({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.passportNumber,
    this.nationality,
    this.dateOfBirth,
    this.gender,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      passportNumber: json['passportNumber'],
      nationality: json['nationality'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'passportNumber': passportNumber,
      'nationality': nationality,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}
