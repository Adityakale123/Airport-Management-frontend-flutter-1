import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../data/models/booking.dart';
import '../../data/models/invoice.dart';
import '../utils/date_formatter.dart';

class PdfGenerator {
  // Generate Ticket PDF
  static Future<File> generateTicket(Booking booking) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(width: 2, color: PdfColors.blue),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'E-TICKET',
                            style: pw.TextStyle(
                              fontSize: 32,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'Airport Management System',
                            style: pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 2),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Text(
                              'PNR',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                            pw.Text(
                              booking.pnr ?? booking.id.toString(),
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Passenger Information
                _buildSection(
                  'PASSENGER INFORMATION',
                  [
                    _buildInfoRow('Name', booking.passenger?.name ?? 'N/A'),
                    _buildInfoRow('Email', booking.passenger?.email ?? 'N/A'),
                    _buildInfoRow('Phone', booking.passenger?.phone ?? 'N/A'),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Flight Information
                _buildSection(
                  'FLIGHT INFORMATION',
                  [
                    _buildInfoRow(
                        'Flight Number', booking.flight?.number ?? 'N/A'),
                    _buildInfoRow('From', booking.flight?.source ?? 'N/A'),
                    _buildInfoRow('To', booking.flight?.destination ?? 'N/A'),
                    _buildInfoRow(
                      'Departure',
                      booking.flight != null
                          ? DateFormatter.formatDateTime(
                              booking.flight!.departureTime)
                          : 'N/A',
                    ),
                    _buildInfoRow(
                      'Arrival',
                      booking.flight != null
                          ? DateFormatter.formatDateTime(
                              booking.flight!.arrivalTime)
                          : 'N/A',
                    ),
                    _buildInfoRow('Seat Number', booking.seatNumber),
                    _buildInfoRow('Status', booking.status),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Booking Details
                _buildSection(
                  'BOOKING DETAILS',
                  [
                    _buildInfoRow(
                      'Booking Date',
                      DateFormatter.formatDate(booking.bookingDate),
                    ),
                    _buildInfoRow(
                        'Amount Paid', '₹${booking.price.toStringAsFixed(2)}'),
                  ],
                ),
                pw.Spacer(),

                // Footer
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Please carry a valid ID proof along with this ticket',
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Report at the airport at least 2 hours before departure',
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
  static Future<File> generateInvoice(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            fontSize: 36,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('Airport Management System'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          invoice.invoiceNumber,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          DateFormatter.formatDate(invoice.invoiceDate),
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Invoice Details
                pw.Table.fromTextArray(
                  headers: ['Description', 'Amount'],
                  data: [
                    ['Booking Amount', '₹${invoice.amount.toStringAsFixed(2)}'],
                    ['Tax & Fees', '₹${invoice.tax.toStringAsFixed(2)}'],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerRight,
                  },
                ),
                pw.SizedBox(height: 20),

                // Total
                pw.Container(
                  padding: pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Amount',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '₹${invoice.totalAmount.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Payment Information
                if (invoice.paymentMethod != null)
                  pw.Container(
                    padding: pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Payment Information',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text('Method: ${invoice.paymentMethod}'),
                        pw.Text('Status: ${invoice.status}'),
                      ],
                    ),
                  ),
                pw.Spacer(),

                // Footer
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey),
                    ),
                  ),
                  child: pw.Text(
                    'Thank you for choosing our services!',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_${invoice.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Helper method to build section
  static pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Container(
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // Helper method to build info row
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
