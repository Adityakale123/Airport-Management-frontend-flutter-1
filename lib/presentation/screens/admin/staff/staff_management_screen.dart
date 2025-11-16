import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/staff_provider.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';

class StaffManagementScreen extends StatefulWidget {
  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  String _searchQuery = '';
  String _selectedRole = 'ALL';

  @override
  void initState() {
    super.initState();
    // Fetch staff data when screen loads
    Future.microtask(() {
      Provider.of<StaffProvider>(context, listen: false).getAllStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_tree),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.adminStaffHierarchy);
            },
            tooltip: 'View Hierarchy',
          ),
        ],
      ),
      body: Consumer<StaffProvider>(
        builder: (context, staffProvider, _) {
          final staffList = staffProvider.staffMembers;

          // Filter staff based on search and role
          final filteredStaff = staffList.where((staff) {
            final fullName = '${staff.firstName} ${staff.lastName}';
            final matchesSearch = fullName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                staff.email.toLowerCase().contains(_searchQuery.toLowerCase());

            final matchesRole = _selectedRole == 'ALL' ||
                staff.role == _selectedRole.replaceAll(' ', '_');
            return matchesSearch && matchesRole;
          }).toList();

          return Column(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildRoleChip('ALL', 'All Staff'),
                    const SizedBox(width: 8),
                    _buildRoleChip('PILOT', 'Pilots'),
                    const SizedBox(width: 8),
                    _buildRoleChip('CABIN_CREW', 'Cabin Crew'),
                    const SizedBox(width: 8),
                    _buildRoleChip('GROUND_STAFF', 'Ground Staff'),
                    const SizedBox(width: 8),
                    _buildRoleChip('ENGINEER', 'Engineers'),
                  ],
                ),
              ),
              Expanded(
                child: staffProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredStaff.isEmpty
                        ? EmptyState(
                            icon: Icons.people,
                            title: 'No Staff Found',
                            subtitle: _searchQuery.isEmpty
                                ? 'Add your first staff member'
                                : 'No staff match your search',
                            actionText: 'Add Staff',
                            onActionPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.adminAddStaff);
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredStaff.length,
                            itemBuilder: (context, index) {
                              final staff = filteredStaff[index];
                              return _buildStaffCard(staff);
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adminAddStaff).then((_) {
            // Refresh staff list when returning from add staff screen
            Provider.of<StaffProvider>(context, listen: false).getAllStaff();
          });
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Staff'),
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

  Widget _buildStaffCard(staff) {
    final fullName = '${staff.firstName} ${staff.lastName}';
    final roleLabel = staff.role.replaceAll('_', ' ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(staff.role).withOpacity(0.2),
          child: Icon(
            _getRoleIcon(staff.role),
            color: _getRoleColor(staff.role),
          ),
        ),
        title: Text(
          fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('$roleLabel • ${staff.email}'),
            Text(
              staff.department ?? 'No Department',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: const [
                  Icon(Icons.visibility, size: 18),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: const [
                  Icon(Icons.delete, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$value - $fullName')),
            );
          },
        ),
        onTap: () {
          _showStaffDetails(staff);
        },
      ),
    );
  }

  void _showStaffDetails(staff) {
    final fullName = '${staff.firstName} ${staff.lastName}';
    final roleLabel = staff.role.replaceAll('_', ' ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Staff Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _getRoleColor(staff.role).withOpacity(0.2),
                  child: Icon(
                    _getRoleIcon(staff.role),
                    size: 40,
                    color: _getRoleColor(staff.role),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRoleColor(staff.role).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    roleLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(staff.role),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(Icons.email, 'Email', staff.email),
              _buildDetailRow(Icons.phone, 'Phone', staff.phone),
              _buildDetailRow(Icons.business_center, 'Department',
                  staff.department ?? 'N/A'),
              _buildDetailRow(Icons.attach_money, 'Salary',
                  staff.salary?.toString() ?? 'N/A'),
              _buildDetailRow(
                  Icons.calendar_today, 'Hire Date', staff.hireDate ?? 'N/A'),
              _buildDetailRow(Icons.info, 'Status', staff.status ?? 'ACTIVE'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit staff')),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact staff')),
                        );
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Contact'),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
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
      case 'PILOT':
        return Icons.flight;
      case 'CABIN_CREW':
        return Icons.airline_seat_recline_extra;
      case 'GROUND_STAFF':
        return Icons.support_agent;
      case 'ENGINEER':
        return Icons.engineering;
      case 'SECURITY':
        return Icons.security;
      case 'MANAGER':
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'PILOT':
        return AppColors.primary;
      case 'CABIN_CREW':
        return AppColors.secondary;
      case 'GROUND_STAFF':
        return AppColors.warning;
      case 'ENGINEER':
        return AppColors.accent;
      case 'SECURITY':
        return AppColors.error;
      case 'MANAGER':
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
