class Staff {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? department;
  final String? assignedFlight;
  final String? employeeId;

  Staff({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.department,
    this.assignedFlight,
    this.employeeId,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'STAFF',
      department: json['department'],
      assignedFlight: json['assignedFlight'],
      employeeId: json['employeeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'assignedFlight': assignedFlight,
      'employeeId': employeeId,
    };
  }
}
