class Staff {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String? hireDate;
  final String? department;
  final double? salary;
  final String? status;
  final int? terminalId;
  final String? terminalName;
  final String? createdAt;
  final String? updatedAt;

  Staff({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.hireDate,
    this.department,
    this.salary,
    this.status,
    this.terminalId,
    this.terminalName,
    this.createdAt,
    this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'GROUND_STAFF',
      hireDate: json['hireDate'],
      department: json['department'],
      salary: json['salary'],
      status: json['status'] ?? 'ACTIVE',
      terminalId: json['terminalId'],
      terminalName: json['terminalName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'hireDate': hireDate,
      'department': department,
      'salary': salary,
      'status': status,
      'terminalId': terminalId,
      'terminalName': terminalName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
