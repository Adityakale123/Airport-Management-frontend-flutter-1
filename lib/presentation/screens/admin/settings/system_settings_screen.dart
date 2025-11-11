import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SystemSettingsScreen extends StatefulWidget {
  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _maintenanceMode = false;
  bool _allowRegistration = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoBackup = true;
  int _sessionTimeout = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'General Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Maintenance Mode'),
                  subtitle: Text('Disable access for users'),
                  secondary: Icon(Icons.build, color: AppColors.warning),
                  value: _maintenanceMode,
                  onChanged: (value) {
                    setState(() => _maintenanceMode = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('Allow User Registration'),
                  subtitle: Text('Enable new user signups'),
                  secondary: Icon(Icons.person_add, color: AppColors.primary),
                  value: _allowRegistration,
                  onChanged: (value) {
                    setState(() => _allowRegistration = value);
                  },
                ),
              ],
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
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Email Notifications'),
                  subtitle: Text('Send system emails'),
                  secondary: Icon(Icons.email, color: AppColors.primary),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() => _emailNotifications = value);
                  },
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('SMS Notifications'),
                  subtitle: Text('Send SMS alerts'),
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
            'Security',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.timer, color: AppColors.primary),
                  title: Text('Session Timeout'),
                  subtitle: Text('$_sessionTimeout minutes'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showTimeoutDialog();
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock, color: AppColors.primary),
                  title: Text('Change Admin Password'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Change password')),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Backup & Recovery',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Auto Backup'),
                  subtitle: Text('Daily automatic backups'),
                  secondary: Icon(Icons.backup, color: AppColors.success),
                  value: _autoBackup,
                  onChanged: (value) {
                    setState(() => _autoBackup = value);
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.cloud_upload, color: AppColors.primary),
                  title: Text('Manual Backup'),
                  subtitle: Text('Create backup now'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Creating backup...')),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.restore, color: AppColors.warning),
                  title: Text('Restore from Backup'),
                  subtitle: Text('Restore system data'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Restore backup')),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'System Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info, color: AppColors.primary),
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.storage, color: AppColors.primary),
                  title: Text('Database Size'),
                  subtitle: Text('125 MB'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.schedule, color: AppColors.primary),
                  title: Text('Last Backup'),
                  subtitle: Text('Today, 2:00 AM'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings saved successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Save Settings'),
          ),
        ],
      ),
    );
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Session Timeout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select session timeout duration:'),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: _sessionTimeout,
              isExpanded: true,
              items: [15, 30, 60, 120].map((minutes) {
                return DropdownMenuItem(
                  value: minutes,
                  child: Text('$minutes minutes'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _sessionTimeout = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
