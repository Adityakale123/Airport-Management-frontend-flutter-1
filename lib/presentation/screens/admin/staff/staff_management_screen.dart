import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';

class StaffManagementScreen extends StatefulWidget {
  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  String _searchQuery = '';
  String _selectedRole = 'ALL';

  // Mock data - replace with actual data from provider
  final List<Map<String, dynamic>> _mockStaff = [
    {
      'id': 1,
      'name': 'John Pilot',
      'email': 'john.pilot@airline.com',
      'phone': '+91 98765 43210',
      'role': AppConstants.staffPilot,
      'employeeId': 'EMP001',
      'department': 'Flight Operations',
    },
    {
      'id': 2,
      'name': 'Sarah Crew',
      'email': 'sarah.crew@airline.com',
      'phone': '+91 98765 43211',
      'role': AppConstants.staffCabinCrew,
      'employeeId': 'EMP002',
      'department': 'Cabin Services',
    },
    {
      'id': 3,
      'name': 'Mike Ground',
      'email': 'mike.ground@airline.com',
      'phone': '+91 98765 43212',
      'role': AppConstants.staffGroundStaff,
      'employeeId': 'EMP003',
      'department': 'Ground Operations',
    },
    {
      'id': 4,
      'name': 'Lisa Engineer',
      'email': 'lisa.engineer@airline.com',
      'phone': '+91 98765 43213',
      'role': AppConstants.staffEngineer,
      'employeeId': 'EMP004',
      'department': 'Engineering',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStaff = _mockStaff.where((staff) {
      final matchesSearch = staff['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          staff['employeeId']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesRole =
          _selectedRole == 'ALL' || staff['role'] == _selectedRole;
      return matchesSearch && matchesRole;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_tree),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.adminStaffHierarchy);
            },
            tooltip: 'View Hierarchy',
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search staff...',
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            onFilterPressed: _showFilterDialog,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildRoleChip('ALL', 'All Staff'),
                SizedBox(width: 8),
                _buildRoleChip(AppConstants.staffPilot, 'Pilots'),
                SizedBox(width: 8),
                _buildRoleChip(AppConstants.staffCabinCrew, 'Cabin Crew'),
                SizedBox(width: 8),
                _buildRoleChip(AppConstants.staffGroundStaff, 'Ground Staff'),
                SizedBox(width: 8),
                _buildRoleChip(AppConstants.staffEngineer, 'Engineers'),
              ],
            ),
          ),
          Expanded(
            child: filteredStaff.isEmpty
                ? EmptyState(
                    icon: Icons.people,
                    title: 'No Staff Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'Add your first staff member'
                        : 'No staff match your search',
                    actionText: 'Add Staff',
                    onActionPressed: () {
                      Navigator.pushNamed(context, AppRoutes.adminAddStaff);
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staff = filteredStaff[index];
                      return _buildStaffCard(staff);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adminAddStaff);
        },
        icon: Icon(Icons.add),
        label: Text('Add Staff'),
      ),
    );
  }

  Widget _buildRoleChip(String role, String label) {
    final isSelected = _selectedRole == role;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedRole = role);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(staff['role']).withOpacity(0.2),
          child: Icon(
            _getRoleIcon(staff['role']),
            color: _getRoleColor(staff['role']),
          ),
        ),
        title: Text(
          staff['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('${staff['role']} • ${staff['employeeId']}'),
            Text(
              staff['department'],
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 18),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
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
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$value - ${staff['name']}')),
            );
          },
        ),
        onTap: () {
          _showStaffDetails(staff);
        },
      ),
    );
  }

  void _showStaffDetails(Map<String, dynamic> staff) {
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
                    'Staff Details',
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
                  backgroundColor:
                      _getRoleColor(staff['role']).withOpacity(0.2),
                  child: Icon(
                    _getRoleIcon(staff['role']),
                    size: 40,
                    color: _getRoleColor(staff['role']),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  staff['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRoleColor(staff['role']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    staff['role'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(staff['role']),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _buildDetailRow(Icons.badge, 'Employee ID', staff['employeeId']),
              _buildDetailRow(
                  Icons.business_center, 'Department', staff['department']),
              _buildDetailRow(Icons.email, 'Email', staff['email']),
              _buildDetailRow(Icons.phone, 'Phone', staff['phone']),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Edit staff')),
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
                          SnackBar(content: Text('Contact staff')),
                        );
                      },
                      icon: Icon(Icons.message),
                      label: Text('Contact'),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          SizedBox(width: 16),
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
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case AppConstants.staffPilot:
        return Icons.flight;
      case AppConstants.staffCabinCrew:
        return Icons.airline_seat_recline_extra;
      case AppConstants.staffGroundStaff:
        return Icons.support_agent;
      case AppConstants.staffEngineer:
        return Icons.engineering;
      case AppConstants.staffSecurity:
        return Icons.security;
      case AppConstants.staffManager:
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case AppConstants.staffPilot:
        return AppColors.primary;
      case AppConstants.staffCabinCrew:
        return AppColors.secondary;
      case AppConstants.staffGroundStaff:
        return AppColors.warning;
      case AppConstants.staffEngineer:
        return AppColors.accent;
      case AppConstants.staffSecurity:
        return AppColors.error;
      case AppConstants.staffManager:
        return AppColors.info;
      default:
        return AppColors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Staff'),
        content: Text('Filter options will be added here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
