import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/booking.dart';
import '../../data/models/flight.dart';
import '../../data/models/payment.dart';

class ExcelExporter {
  // Export Bookings to Excel
  static Future<File> exportBookings(List<Booking> bookings) async {
    final excel = Excel.createExcel();
    final sheet = excel['Bookings'];

    // Header Row
    sheet.appendRow([
      'ID',
      'PNR',
      'Passenger',
      'Flight',
      'Seat',
      'Amount',
      'Status',
      'Booking Date',
    ]);

    // Data Rows
    for (var booking in bookings) {
      sheet.appendRow([
        booking.id.toString(),
        booking.pnr ?? '',
        booking.passenger?.name ?? '',
        booking.flight?.number ?? '',
        booking.seatNo,
        booking.amount.toString(),
        booking.status,
        booking.bookingDate.toString().split(' ')[0],
      ]);
    }

    // Save file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/bookings_export.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  // Export Flights to Excel
  static Future<File> exportFlights(List<Flight> flights) async {
    final excel = Excel.createExcel();
    final sheet = excel['Flights'];

    // Header Row
    sheet.appendRow([
      'ID',
      'Number',
      'Airline',
      'Source',
      'Destination',
      'Departure',
      'Arrival',
      'Status',
      'Price',
      'Available Seats',
    ]);

    // Data Rows
    for (var flight in flights) {
      sheet.appendRow([
        flight.id.toString(),
        flight.number,
        flight.airline,
        flight.source,
        flight.destination,
        flight.departureTime.toString(),
        flight.arrivalTime.toString(),
        flight.status,
        flight.price.toString(),
        flight.availableSeats.toString(),
      ]);
    }

    // Save file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/flights_export.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  // Export Payments to Excel
  static Future<File> exportPayments(List<Payment> payments) async {
    final excel = Excel.createExcel();
    final sheet = excel['Payments'];

    // Header Row
    sheet.appendRow([
      'ID',
      'Booking ID',
      'Amount',
      'Method',
      'Status',
      'Transaction ID',
      'Date',
    ]);

    // Data Rows
    for (var payment in payments) {
      sheet.appendRow([
        payment.id.toString(),
        payment.bookingId.toString(),
        payment.amount.toString(),
        payment.method,
        payment.status,
        payment.transactionId ?? '',
        payment.paymentDate.toString().split(' ')[0],
      ]);
    }

    // Save file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/payments_export.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  // Export Revenue Report to Excel
  static Future<File> exportRevenueReport(
    Map<String, dynamic> revenueData,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Revenue Report'];

    // Summary Section
    sheet.appendRow(['Revenue Report']);
    sheet.appendRow([]);
    sheet.appendRow(['Total Revenue', revenueData['totalRevenue'].toString()]);
    sheet.appendRow(
        ['Monthly Revenue', revenueData['monthlyRevenue'].toString()]);
    sheet
        .appendRow(['Yearly Revenue', revenueData['yearlyRevenue'].toString()]);
    sheet.appendRow([]);

    // Monthly Breakdown
    if (revenueData['monthlyData'] != null) {
      sheet.appendRow(['Month', 'Revenue']);
      for (var data in revenueData['monthlyData']) {
        sheet.appendRow([data['month'], data['revenue'].toString()]);
      }
    }

    // Save file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/revenue_report.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }
}
