import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class StaffHierarchyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Hierarchy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organizational Structure',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            _buildHierarchyLevel(
              'Management',
              AppConstants.staffManager,
              [
                {'name': 'John Manager', 'id': 'EMP001'},
              ],
              AppColors.primary,
              0,
            ),
            _buildHierarchyLevel(
              'Flight Operations',
              AppConstants.staffPilot,
              [
                {'name': 'Sarah Pilot', 'id': 'EMP002'},
                {'name': 'Mike Pilot', 'id': 'EMP003'},
              ],
              AppColors.secondary,
              1,
            ),
            _buildHierarchyLevel(
              'Cabin Crew',
              AppConstants.staffCabinCrew,
              [
                {'name': 'Lisa Crew', 'id': 'EMP004'},
                {'name': 'Anna Crew', 'id': 'EMP005'},
                {'name': 'Tom Crew', 'id': 'EMP006'},
              ],
              AppColors.warning,
              1,
            ),
            _buildHierarchyLevel(
              'Ground Operations',
              AppConstants.staffGroundStaff,
              [
                {'name': 'David Ground', 'id': 'EMP007'},
                {'name': 'Emma Ground', 'id': 'EMP008'},
              ],
              AppColors.accent,
              1,
            ),
            _buildHierarchyLevel(
              'Engineering',
              AppConstants.staffEngineer,
              [
                {'name': 'Robert Engineer', 'id': 'EMP009'},
              ],
              AppColors.info,
              1,
            ),
            _buildHierarchyLevel(
              'Security',
              AppConstants.staffSecurity,
              [
                {'name': 'James Security', 'id': 'EMP010'},
                {'name': 'Chris Security', 'id': 'EMP011'},
              ],
              AppColors.error,
              1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHierarchyLevel(
    String department,
    String role,
    List<Map<String, String>> staff,
    Color color,
    int level,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: level * 20.0, bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_getRoleIcon(role), color: color),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          department,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          '${staff.length} member${staff.length > 1 ? 's' : ''}',
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
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: staff.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final member = staff[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Text(
                        member['name']!.substring(0, 1),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(member['name']!),
                    subtitle: Text(member['id']!),
                    trailing: Icon(Icons.chevron_right, size: 20),
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case AppConstants.staffManager:
        return Icons.manage_accounts;
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
      default:
        return Icons.person;
    }
  }
}