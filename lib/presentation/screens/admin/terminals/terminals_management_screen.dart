import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';

class TerminalsManagementScreen extends StatefulWidget {
  @override
  State<TerminalsManagementScreen> createState() =>
      _TerminalsManagementScreenState();
}

class _TerminalsManagementScreenState extends State<TerminalsManagementScreen> {
  String _searchQuery = '';

  // Mock data
  final List<Map<String, dynamic>> _mockTerminals = [
    {
      'id': 1,
      'name': 'Terminal 1',
      'gateNo': 'T1',
      'status': 'OPERATIONAL',
      'capacity': 50,
      'gates': ['T1-G1', 'T1-G2', 'T1-G3', 'T1-G4', 'T1-G5'],
      'currentFlights': 12,
    },
    {
      'id': 2,
      'name': 'Terminal 2',
      'gateNo': 'T2',
      'status': 'OPERATIONAL',
      'capacity': 75,
      'gates': ['T2-G1', 'T2-G2', 'T2-G3', 'T2-G4', 'T2-G5', 'T2-G6', 'T2-G7'],
      'currentFlights': 18,
    },
    {
      'id': 3,
      'name': 'Terminal 3',
      'gateNo': 'T3',
      'status': 'MAINTENANCE',
      'capacity': 100,
      'gates': [
        'T3-G1',
        'T3-G2',
        'T3-G3',
        'T3-G4',
        'T3-G5',
        'T3-G6',
        'T3-G7',
        'T3-G8',
        'T3-G9',
        'T3-G10'
      ],
      'currentFlights': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTerminals = _mockTerminals.where((terminal) {
      return terminal['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Terminals Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refreshing terminal data...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search terminals...',
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          Expanded(
            child: filteredTerminals.isEmpty
                ? EmptyState(
                    icon: Icons.business,
                    title: 'No Terminals Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'No terminals available'
                        : 'No terminals match your search',
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredTerminals.length,
                    itemBuilder: (context, index) {
                      final terminal = filteredTerminals[index];
                      return _buildTerminalCard(terminal);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add terminal functionality')),
          );
        },
        icon: Icon(Icons.add),
        label: Text('Add Terminal'),
      ),
    );
  }

  Widget _buildTerminalCard(Map<String, dynamic> terminal) {
    final isOperational = terminal['status'] == 'OPERATIONAL';
    final Color statusColor =
        isOperational ? AppColors.success : AppColors.warning;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTerminalDetails(terminal),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.business, color: AppColors.primary),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            terminal['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${terminal['gates'].length} Gates',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      terminal['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoTile(
                      'Capacity',
                      '${terminal['capacity']} flights',
                      Icons.event_seat,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.greyLight),
                  Expanded(
                    child: _buildInfoTile(
                      'Current',
                      '${terminal['currentFlights']} flights',
                      Icons.flight,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.greyLight),
                  Expanded(
                    child: _buildInfoTile(
                      'Available',
                      '${terminal['capacity'] - terminal['currentFlights']}',
                      Icons.check_circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('View gates')),
                      );
                    },
                    icon: Icon(Icons.meeting_room, size: 18),
                    label: Text('View Gates'),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit terminal')),
                      );
                    },
                    icon: Icon(Icons.edit, size: 18),
                    label: Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showTerminalDetails(Map<String, dynamic> terminal) {
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
                    terminal['name'],
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
              _buildDetailRow('Gate Number', terminal['gateNo']),
              _buildDetailRow('Status', terminal['status']),
              _buildDetailRow('Capacity', '${terminal['capacity']} flights'),
              _buildDetailRow(
                'Current Flights',
                '${terminal['currentFlights']}',
              ),
              SizedBox(height: 24),
              Text(
                'Available Gates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (terminal['gates'] as List<String>).map((gate) {
                  return Chip(
                    label: Text(gate),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Manage gates')),
                  );
                },
                child: Text('Manage Gates'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
