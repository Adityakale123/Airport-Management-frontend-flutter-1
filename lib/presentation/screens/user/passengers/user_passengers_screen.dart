import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../widgets/cards/passenger_card.dart';
import '../../../widgets/dialogs/confirmation_dialog.dart';

class UserPassengersScreen extends StatefulWidget {
  @override
  State<UserPassengersScreen> createState() => _UserPassengersScreenState();
}

class _UserPassengersScreenState extends State<UserPassengersScreen> {
  String _searchQuery = '';

  // Mock data - Replace with actual data from provider
  final List<Map<String, dynamic>> _mockPassengers = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 98765 43210',
      'passportNumber': 'AB1234567',
      'nationality': 'Indian',
      'dateOfBirth': DateTime(1990, 5, 15),
      'gender': 'MALE',
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '+91 98765 43211',
      'passportNumber': 'CD7890123',
      'nationality': 'Indian',
      'dateOfBirth': DateTime(1992, 8, 20),
      'gender': 'FEMALE',
    },
    {
      'id': 3,
      'name': 'Bob Johnson',
      'email': 'bob.johnson@example.com',
      'phone': '+91 98765 43212',
      'passportNumber': 'EF4567890',
      'nationality': 'American',
      'dateOfBirth': DateTime(1985, 12, 10),
      'gender': 'MALE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPassengers = _mockPassengers.where((passenger) {
      return passenger['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Passengers'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Passenger Information'),
                  content: Text(
                    'Add passenger details to quickly book flights for family and friends.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search passengers...',
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          Expanded(
            child: filteredPassengers.isEmpty
                ? EmptyState(
                    icon: Icons.people,
                    title: 'No Passengers Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'Add passengers to book flights quickly'
                        : 'No passengers match your search',
                    actionText: 'Add Passenger',
                    onActionPressed: () {
                      // Navigator.pushNamed(context, AppRoutes.addPassenger);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Add passenger functionality')),
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredPassengers.length,
                    itemBuilder: (context, index) {
                      final passenger = filteredPassengers[index];
                      return _buildPassengerCard(passenger);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.addPassenger);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add passenger functionality')),
          );
        },
        icon: Icon(Icons.person_add),
        label: Text('Add Passenger'),
      ),
    );
  }

  Widget _buildPassengerCard(Map<String, dynamic> passenger) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showPassengerDetails(passenger),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  passenger['name'].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passenger['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email, size: 14, color: AppColors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            passenger['email'],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: AppColors.grey),
                        SizedBox(width: 4),
                        Text(
                          passenger['phone'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit passenger')),
                    );
                  } else if (value == 'delete') {
                    final confirmed = await ConfirmationDialog.show(
                      context,
                      title: 'Delete Passenger',
                      message:
                          'Are you sure you want to delete this passenger?',
                      confirmText: 'Delete',
                      isDanger: true,
                    );

                    if (confirmed == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Passenger deleted'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPassengerDetails(Map<String, dynamic> passenger) {
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
                    'Passenger Details',
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
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    passenger['name'].toString().substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  passenger['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              _buildDetailRow(Icons.email, 'Email', passenger['email']),
              SizedBox(height: 12),
              _buildDetailRow(Icons.phone, 'Phone', passenger['phone']),
              SizedBox(height: 12),
              _buildDetailRow(
                Icons.flight,
                'Passport',
                passenger['passportNumber'] ?? 'Not provided',
              ),
              SizedBox(height: 12),
              _buildDetailRow(
                Icons.flag,
                'Nationality',
                passenger['nationality'] ?? 'Not provided',
              ),
              SizedBox(height: 12),
              _buildDetailRow(Icons.wc, 'Gender', passenger['gender']),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Edit passenger')),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Book flight for passenger')),
                        );
                      },
                      icon: Icon(Icons.flight_takeoff),
                      label: Text('Book Flight'),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
