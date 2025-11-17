import '../services/api_service.dart';
import '../models/billing.dart';
import '../../core/constants/api_endpoints.dart';

class BillingRepository {
  Future<BillingData> getBillingData() async {
    try {
      // Use payment analytics endpoint
      final response = await ApiService.get(ApiEndpoints.paymentAnalytics);
      return BillingData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch billing data: ${e.toString()}');
    }
  }

  Future<List<Invoice>> getInvoices() async {
    try {
      // Get from bookings - each booking can be treated as an invoice
      final response = await ApiService.get('/admin/bookings');

      if (response is List) {
        return response.map((booking) {
          return Invoice(
            id: booking['id']?.toString() ?? '',
            customerName: booking['passengerName'] ?? 'Unknown',
            pnr: booking['pnr'] ?? 'N/A',
            date: booking['createdAt'] != null
                ? DateTime.parse(booking['createdAt'])
                : DateTime.now(),
            amount: (booking['price'] ?? 0).toDouble(),
            status: booking['paymentStatus'] ?? 'PENDING',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch invoices: ${e.toString()}');
    }
  }

  Future<List<Payment>> getPayments() async {
    try {
      // Get from bookings - each confirmed booking is a payment
      final response = await ApiService.get('/admin/bookings');

      if (response is List) {
        return response.map((booking) {
          return Payment(
            id: 'TXN${booking['id']}',
            amount: (booking['price'] ?? 0).toDouble(),
            method: 'Card', // Default - you can add this field to booking model
            status: booking['paymentStatus'] ?? 'PENDING',
            date: booking['createdAt'] != null
                ? DateTime.parse(booking['createdAt'])
                : DateTime.now(),
            reason:
                booking['paymentStatus'] == 'FAILED' ? 'Payment failed' : null,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch payments: ${e.toString()}');
    }
  }
}

// import '../services/api_service.dart';
// import '../models/billing.dart';

// class BillingRepository {
//   Future<BillingData> getBillingData() async {
//     try {
//       // For now, use analytics endpoint
//       final response = await ApiService.get('/admin/analytics');
//       return BillingData.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to fetch billing data: ${e.toString()}');
//     }
//   }

//   Future<List<Invoice>> getInvoices() async {
//     try {
//       // This endpoint needs to be created in backend
//       final response = await ApiService.get('/admin/billing/invoices');
//       return (response as List).map((e) => Invoice.fromJson(e)).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch invoices: ${e.toString()}');
//     }
//   }

//   Future<List<Payment>> getPayments() async {
//     try {
//       // This endpoint needs to be created in backend
//       final response = await ApiService.get('/admin/billing/payments');
//       return (response as List).map((e) => Payment.fromJson(e)).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch payments: ${e.toString()}');
//     }
//   }
// }
