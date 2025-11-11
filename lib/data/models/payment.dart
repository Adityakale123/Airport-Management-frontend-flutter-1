class Payment {
  final int? id;
  final int bookingId;
  final double amount;
  final String method;
  final String status;
  final DateTime paymentDate;
  final String? transactionId;
  final String? cardLast4;

  Payment({
    this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    required this.paymentDate,
    this.transactionId,
    this.cardLast4,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['bookingId'],
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['method'] ?? 'CARD',
      status: json['status'] ?? 'PENDING',
      paymentDate: DateTime.parse(
        json['paymentDate'] ?? DateTime.now().toIso8601String(),
      ),
      transactionId: json['transactionId'],
      cardLast4: json['cardLast4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'method': method,
      'status': status,
      'paymentDate': paymentDate.toIso8601String(),
      'transactionId': transactionId,
      'cardLast4': cardLast4,
    };
  }
}
