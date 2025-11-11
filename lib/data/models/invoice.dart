class Invoice {
  final int? id;
  final int bookingId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double amount;
  final double tax;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  
  // Populated fields
  final Map<String, dynamic>? booking;

  Invoice({
    this.id,
    required this.bookingId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.amount,
    required this.tax,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.booking,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      bookingId: json['bookingId'] ?? 0,
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceDate: DateTime.parse(
        json['invoiceDate'] ?? DateTime.now().toIso8601String(),
      ),
      amount: (json['amount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'UNPAID',
      paymentMethod: json['paymentMethod'],
      booking: json['booking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate.toIso8601String(),
      'amount': amount,
      'tax': tax,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  double get subtotal => amount;
  double get taxAmount => tax;
  double get total => totalAmount;
}