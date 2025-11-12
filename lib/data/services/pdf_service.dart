import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/booking.dart';

class PdfService {
  // Generate Ticket PDF
  static Future<File> generateTicket(Booking booking) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'E-TICKET',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Booking Reference: ${booking.pnr ?? booking.id}'),
              pw.SizedBox(height: 10),
              pw.Text('Passenger: ${booking.passenger?.name ?? 'N/A'}'),
              pw.Text('Flight: ${booking.flight?.number ?? 'N/A'}'),
              pw.Text('From: ${booking.flight?.source ?? 'N/A'}'),
              pw.Text('To: ${booking.flight?.destination ?? 'N/A'}'),
              pw.Text('Seat: ${booking.seatNo}'),
              pw.Text('Amount: ₹${booking.amount}'),
              pw.SizedBox(height: 20),
              pw.Text('Status: ${booking.status}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/ticket_${booking.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Generate Invoice PDF
  static Future<File> generateInvoice(
    Booking booking,
    Map<String, dynamic> paymentDetails,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Invoice #: INV${booking.id}'),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Text('Customer Details:'),
              pw.Text('Name: ${booking.passenger?.name}'),
              pw.Text('Email: ${booking.passenger?.email}'),
              pw.SizedBox(height: 20),
              pw.Text('Flight Details:'),
              pw.Text('Flight: ${booking.flight?.number}'),
              pw.Text(
                  'Route: ${booking.flight?.source} → ${booking.flight?.destination}'),
              pw.Text('Seat: ${booking.seatNo}'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Amount:'),
                  pw.Text(
                    '₹${booking.amount}',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_${booking.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Print PDF
  static Future<void> printPdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  // Share PDF
  static Future<void> sharePdf(File pdfFile) async {
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: pdfFile.path.split('/').last,
    );
  }
}
