import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/common/loading_indicator.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<AnalyticsProvider>(context, listen: false).getAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _getSelectedScreen(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final user = Provider.of<AuthProvider>(context).user;

    return AppBar(
      title: Text('Admin Dashboard'),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'A',
                style: TextStyle(color: Colors.white),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, AppRoutes.adminSettings);
              } else if (value == 'logout') {
                _handleLogout();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 0);
            },
          ),
          _buildDrawerItem(
            icon: Icons.flight,
            title: 'Flights',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminFlights);
            },
          ),
          _buildDrawerItem(
            icon: Icons.people,
            title: 'Staff Management',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminStaff);
            },
          ),
          _buildDrawerItem(
            icon: Icons.business,
            title: 'Terminals',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminTerminals);
            },
          ),
          _buildDrawerItem(
            icon: Icons.payment,
            title: 'Billing',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminBilling);
            },
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            title: 'Analytics',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminAnalytics);
            },
          ),
          _buildDrawerItem(
            icon: Icons.group,
            title: 'User Management',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminUserManagement);
            },
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.adminSettings);
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? AppColors.textPrimary),
      ),
      onTap: onTap,
    );
  }

  Widget _getSelectedScreen() {
    return _DashboardHome();
  }

  Future<void> _handleLogout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}

class _DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return LoadingIndicator(message: 'Loading analytics...');
        }

        final analytics = provider.analytics;

        return RefreshIndicator(
          onRefresh: () async {
            await provider.getAnalytics();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      title: 'Total Flights',
                      value: analytics?.totalFlights.toString() ?? '0',
                      icon: Icons.flight_takeoff,
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.adminFlights,
                      ),
                    ),
                    StatCard(
                      title: 'Total Bookings',
                      value: analytics?.totalBookings.toString() ?? '0',
                      icon: Icons.confirmation_number,
                      color: AppColors.secondary,
                    ),
                    StatCard(
                      title: 'Total Passengers',
                      value: analytics?.totalPassengers.toString() ?? '0',
                      icon: Icons.people,
                      color: AppColors.warning,
                    ),
                    StatCard(
                      title: 'Total Staff',
                      value: analytics?.totalStaff.toString() ?? '0',
                      icon: Icons.badge,
                      color: AppColors.accent,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.adminStaff,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Revenue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success,
                          AppColors.successGradient.colors[1]
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Revenue',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '₹${analytics?.totalRevenue.toStringAsFixed(2) ?? '0'}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.trending_up,
                                color: Colors.white, size: 48),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildRevenueItem(
                              'Monthly',
                              '₹${analytics?.monthlyRevenue.toStringAsFixed(2) ?? '0'}',
                            ),
                            Container(
                                width: 1, height: 40, color: Colors.white30),
                            _buildRevenueItem(
                              'Yearly',
                              '₹${analytics?.yearlyRevenue.toStringAsFixed(2) ?? '0'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildQuickAction(
                      context,
                      'Add Flight',
                      Icons.add_circle,
                      AppColors.primary,
                      () => Navigator.pushNamed(
                          context, AppRoutes.adminAddFlight),
                    ),
                    _buildQuickAction(
                      context,
                      'Add Staff',
                      Icons.person_add,
                      AppColors.secondary,
                      () =>
                          Navigator.pushNamed(context, AppRoutes.adminAddStaff),
                    ),
                    _buildQuickAction(
                      context,
                      'View Analytics',
                      Icons.bar_chart,
                      AppColors.warning,
                      () => Navigator.pushNamed(
                          context, AppRoutes.adminAnalytics),
                    ),
                    _buildQuickAction(
                      context,
                      'Billing',
                      Icons.receipt_long,
                      AppColors.accent,
                      () =>
                          Navigator.pushNamed(context, AppRoutes.adminBilling),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevenueItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
