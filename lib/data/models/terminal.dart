class Terminal {
  final int? id;
  final String name;
  final String code;
  final int capacity;
  final String status;
  final String? facilities;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Terminal({
    this.id,
    required this.name,
    required this.code,
    required this.capacity,
    required this.status,
    this.facilities,
    this.createdAt,
    this.updatedAt,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'OPERATIONAL',
      facilities: json['facilities'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'capacity': capacity,
      'status': status,
      'facilities': facilities,
    };
  }
}
