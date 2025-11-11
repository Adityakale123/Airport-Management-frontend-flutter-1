import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';

class InvoicesScreen extends StatefulWidget {
  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'ALL';

  // Mock data
  final List<Map<String, dynamic>> _mockInvoices = [
    {
      'id': 1,
      'invoiceNumber': 'INV-2024-001',
      'bookingPnr': 'ABC123',
      'amount': 5000.0,
      'tax': 600.0,
      'totalAmount': 5600.0,
      'status': 'PAID',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'customerName': 'John Doe',
    },
    {
      'id': 2,
      'invoiceNumber': 'INV-2024-002',
      'bookingPnr': 'DEF456',
      'amount': 3500.0,
      'tax': 420.0,
      'totalAmount': 3920.0,
      'status': 'UNPAID',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'customerName': 'Jane Smith',
    },
    {
      'id': 3,
      'invoiceNumber': 'INV-2024-003',
      'bookingPnr': 'GHI789',
      'amount': 7200.0,
      'tax': 864.0,
      'totalAmount': 8064.0,
      'status': 'PAID',
      'date': DateTime.now().subtract(Duration(days: 10)),
      'customerName': 'Bob Johnson',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = _mockInvoices.where((invoice) {
      final matchesSearch = invoice['invoiceNumber']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          invoice['customerName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _selectedStatus == 'ALL' || invoice['status'] == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exporting invoices...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search invoices...',
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildStatusChip('ALL', 'All'),
                SizedBox(width: 8),
                _buildStatusChip('PAID', 'Paid'),
                SizedBox(width: 8),
                _buildStatusChip('UNPAID', 'Unpaid'),
                SizedBox(width: 8),
                _buildStatusChip('OVERDUE', 'Overdue'),
              ],
            ),
          ),
          Expanded(
            child: filteredInvoices.isEmpty
                ? EmptyState(
                    icon: Icons.receipt_long,
                    title: 'No Invoices Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'No invoices available'
                        : 'No invoices match your search',
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = filteredInvoices[index];
                      return _buildInvoiceCard(invoice);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final isSelected = _selectedStatus == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedStatus = status);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    final isPaid = invoice['status'] == 'PAID';

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showInvoiceDetails(invoice),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice['invoiceNumber'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isPaid ? AppColors.success : AppColors.error)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      invoice['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text(invoice['customerName']),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.confirmation_number,
                      size: 16, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text('PNR: ${invoice['bookingPnr']}'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text(DateFormatter.formatDate(invoice['date'])),
                ],
              ),
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '₹${invoice['totalAmount']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvoiceDetails(Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invoice Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildDetailRow('Invoice Number', invoice['invoiceNumber']),
              _buildDetailRow('Customer', invoice['customerName']),
              _buildDetailRow('Booking PNR', invoice['bookingPnr']),
              _buildDetailRow(
                'Date',
                DateFormatter.formatDate(invoice['date']),
              ),
              Divider(height: 32),
              _buildDetailRow('Amount', '₹${invoice['amount']}'),
              _buildDetailRow('Tax (12%)', '₹${invoice['tax']}'),
              Divider(height: 32),
              _buildDetailRow(
                'Total Amount',
                '₹${invoice['totalAmount']}',
                isTotal: true,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading invoice...')),
                        );
                      },
                      icon: Icon(Icons.download),
                      label: Text('Download'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sending invoice...')),
                        );
                      },
                      icon: Icon(Icons.email),
                      label: Text('Email'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
