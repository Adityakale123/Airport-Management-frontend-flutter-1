class Terminal {
  final int? id;
  final String name;
  final String gateNo;
  final String? status;
  final int? capacity;

  Terminal({
    this.id,
    required this.name,
    required this.gateNo,
    this.status,
    this.capacity,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      name: json['name'] ?? '',
      gateNo: json['gateNo'] ?? '',
      status: json['status'],
      capacity: json['capacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gateNo': gateNo,
      'status': status,
      'capacity': capacity,
    };
  }
}
