class User {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final String? avatar;
  final String? createdAt;
  final String? aadharNumber;
  final String? aadharPhotoUrl;
  final String? panNumber;
  final String? panPhotoUrl;
  final String? passportNumber;
  final String? passportPhotoUrl;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.avatar,
    this.createdAt,
    this.aadharNumber,
    this.aadharPhotoUrl,
    this.panNumber,
    this.panPhotoUrl,
    this.passportNumber,
    this.passportPhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
      createdAt: json['createdAt'],
      aadharNumber: json['aadharNumber'],
      aadharPhotoUrl: json['aadharPhotoUrl'],
      panNumber: json['panNumber'],
      panPhotoUrl: json['panPhotoUrl'],
      passportNumber: json['passportNumber'],
      passportPhotoUrl: json['passportPhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'createdAt': createdAt,
      'aadharNumber': aadharNumber,
      'aadharPhotoUrl': aadharPhotoUrl,
      'panNumber': panNumber,
      'panPhotoUrl': panPhotoUrl,
      'passportNumber': passportNumber,
      'passportPhotoUrl': passportPhotoUrl,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? avatar,
    String? createdAt,
    String? aadharNumber,
    String? aadharPhotoUrl,
    String? panNumber,
    String? panPhotoUrl,
    String? passportNumber,
    String? passportPhotoUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      aadharPhotoUrl: aadharPhotoUrl ?? this.aadharPhotoUrl,
      panNumber: panNumber ?? this.panNumber,
      panPhotoUrl: panPhotoUrl ?? this.panPhotoUrl,
      passportNumber: passportNumber ?? this.passportNumber,
      passportPhotoUrl: passportPhotoUrl ?? this.passportPhotoUrl,
    );
  }
}



// class User {
//   final int? id;
//   final String name;
//   final String email;
//   final String role;
//   final String? phone;
//   final String? avatar;

//   User({
//     this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     this.phone,
//     this.avatar,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       role: json['role'] ?? 'USER',
//       phone: json['phone'],
//       avatar: json['avatar'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'role': role,
//       'phone': phone,
//       'avatar': avatar,
//     };
//   }

//   User copyWith({
//     int? id,
//     String? name,
//     String? email,
//     String? role,
//     String? phone,
//     String? avatar,
//   }) {
//     return User(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       role: role ?? this.role,
//       phone: phone ?? this.phone,
//       avatar: avatar ?? this.avatar,
//     );
//   }
// }
