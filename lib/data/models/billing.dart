class BillingData {
  final double totalRevenue;
  final double monthlyRevenue;
  final int totalInvoices;
  final int pendingPayments;
  final List<Transaction>? recentTransactions;

  BillingData({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalInvoices,
    required this.pendingPayments,
    this.recentTransactions,
  });

  factory BillingData.fromJson(Map<String, dynamic> json) {
    return BillingData(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      totalInvoices: json['totalInvoices'] ?? 0,
      pendingPayments: json['pendingPayments'] ?? 0,
      recentTransactions: json['recentTransactions'] != null
          ? (json['recentTransactions'] as List)
              .map((e) => Transaction.fromJson(e))
              .toList()
          : null,
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final String status;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}

class Invoice {
  final String id;
  final String customerName;
  final String pnr;
  final DateTime date;
  final double amount;
  final String status;

  Invoice({
    required this.id,
    required this.customerName,
    required this.pnr,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      pnr: json['pnr'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
    );
  }
}

class Payment {
  final String id;
  final double amount;
  final String method;
  final String status;
  final DateTime date;
  final String? reason;

  Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
    this.reason,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['method'] ?? '',
      status: json['status'] ?? 'PENDING',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      reason: json['reason'],
    );
  }
}
