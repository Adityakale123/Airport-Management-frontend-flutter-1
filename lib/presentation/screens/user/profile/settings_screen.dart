import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/theme_provider.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _flightUpdates = true;
  bool _bookingConfirmations = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text('Enable dark theme'),
                  secondary: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Email Notifications'),
                  subtitle: Text('Receive updates via email'),
                  secondary: Icon(Icons.email, color: AppColors.primary),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() => _emailNotifications = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('Push Notifications'),
                  subtitle: Text('Receive push notifications'),
                  secondary:
                      Icon(Icons.notifications, color: AppColors.primary),
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() => _pushNotifications = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('SMS Notifications'),
                  subtitle: Text('Receive SMS updates'),
                  secondary: Icon(Icons.sms, color: AppColors.primary),
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() => _smsNotifications = value);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Flight Updates'),
                  subtitle: Text('Status changes, delays, cancellations'),
                  secondary: Icon(Icons.flight, color: AppColors.primary),
                  value: _flightUpdates,
                  onChanged: (value) {
                    setState(() => _flightUpdates = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('Booking Confirmations'),
                  subtitle: Text('New bookings and modifications'),
                  secondary:
                      Icon(Icons.confirmation_number, color: AppColors.primary),
                  value: _bookingConfirmations,
                  onChanged: (value) {
                    setState(() => _bookingConfirmations = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('Promotions & Offers'),
                  subtitle: Text('Special deals and discounts'),
                  secondary: Icon(Icons.local_offer, color: AppColors.primary),
                  value: _promotions,
                  onChanged: (value) {
                    setState(() => _promotions = value);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info, color: AppColors.primary),
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.description, color: AppColors.primary),
                  title: Text('Terms & Conditions'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terms & Conditions')),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: AppColors.primary),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Privacy Policy')),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.star, color: AppColors.primary),
                  title: Text('Rate Us'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rate Us')),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Card(
            color: AppColors.error.withOpacity(0.1),
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: AppColors.error),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Permanently delete your account and data'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Account'),
                    content: Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Account deletion requested'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
