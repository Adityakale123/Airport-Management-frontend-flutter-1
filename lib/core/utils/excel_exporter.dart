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
      TextCellValue('ID'),
      TextCellValue('PNR'),
      TextCellValue('Passenger'),
      TextCellValue('Flight'),
      TextCellValue('Seat'),
      TextCellValue('Amount'),
      TextCellValue('Status'),
      TextCellValue('Booking Date'),
    ]);

    // Data Rows
    for (var booking in bookings) {
      sheet.appendRow([
        TextCellValue(booking.id.toString()),
        TextCellValue(booking.pnr ?? ''),
        TextCellValue(booking.passenger?.name ?? ''),
        TextCellValue(booking.flight?.number ?? ''),
        TextCellValue(booking.seatNumber),
        TextCellValue(booking.price.toStringAsFixed(2)),
        TextCellValue(booking.status),
        TextCellValue(booking.bookingDate.toString().split(' ')[0]),
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
      TextCellValue('ID'),
      TextCellValue('Flight Number'),
      TextCellValue('Aircraft Model'),
      TextCellValue('Origin'),
      TextCellValue('Destination'),
      TextCellValue('Departure'),
      TextCellValue('Arrival'),
      TextCellValue('Status'),
      TextCellValue('Economy Price'),
      TextCellValue('Business Price'),
      TextCellValue('First Class Price'),
      TextCellValue('Available Seats'),
    ]);

    // Data Rows
    for (var flight in flights) {
      sheet.appendRow([
        TextCellValue(flight.id.toString()),
        TextCellValue(flight.flightNumber), // ✅ UPDATED
        TextCellValue(flight.aircraftModel ?? 'N/A'), // ✅ UPDATED
        TextCellValue(flight.origin), // ✅ UPDATED
        TextCellValue(flight.destination),
        TextCellValue(flight.departureTime.toString()),
        TextCellValue(flight.arrivalTime.toString()),
        TextCellValue(flight.status),
        TextCellValue(flight.economyPrice.toString()), // ✅ UPDATED
        TextCellValue(flight.businessPrice.toString()), // ✅ ADDED
        TextCellValue(flight.firstClassPrice.toString()), // ✅ ADDED
        TextCellValue(flight.availableSeats.toString()),
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
      TextCellValue('ID'),
      TextCellValue('Booking ID'),
      TextCellValue('Amount'),
      TextCellValue('Method'),
      TextCellValue('Status'),
      TextCellValue('Transaction ID'),
      TextCellValue('Date'),
    ]);

    // Data Rows
    for (var payment in payments) {
      sheet.appendRow([
        TextCellValue(payment.id.toString()),
        TextCellValue(payment.bookingId.toString()),
        TextCellValue(payment.amount.toString()),
        TextCellValue(payment.method),
        TextCellValue(payment.status),
        TextCellValue(payment.transactionId ?? ''),
        TextCellValue(payment.paymentDate.toString().split(' ')[0]),
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
    sheet.appendRow([TextCellValue('Revenue Report')]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue('Total Revenue'),
      TextCellValue(revenueData['totalRevenue'].toString())
    ]);
    sheet.appendRow([
      TextCellValue('Monthly Revenue'),
      TextCellValue(revenueData['monthlyRevenue'].toString())
    ]);
    sheet.appendRow([
      TextCellValue('Yearly Revenue'),
      TextCellValue(revenueData['yearlyRevenue'].toString())
    ]);
    sheet.appendRow([]);

    // Monthly Breakdown
    if (revenueData['monthlyData'] != null) {
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Revenue')]);
      for (var data in revenueData['monthlyData']) {
        sheet.appendRow([
          TextCellValue(data['month']),
          TextCellValue(data['revenue'].toString())
        ]);
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
