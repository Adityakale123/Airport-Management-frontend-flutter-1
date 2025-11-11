import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class AddStaffScreen extends StatefulWidget {
  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _departmentController = TextEditingController();

  String _selectedRole = AppConstants.staffPilot;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Staff member added successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff Member'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _nameController,
              labelText: 'Full Name',
              hintText: 'Enter full name',
              prefixIcon: Icons.person,
              validator: Validators.validateName,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter email address',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone',
              hintText: 'Enter phone number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),
            SizedBox(height: 24),
            Text(
              'Employment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _employeeIdController,
              labelText: 'Employee ID',
              hintText: 'e.g., EMP001',
              prefixIcon: Icons.badge,
              validator: (value) =>
                  Validators.validateRequired(value, 'Employee ID'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.work),
                filled: true,
                fillColor: AppColors.greyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: AppColors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              items: [
                AppConstants.staffPilot,
                AppConstants.staffCabinCrew,
                AppConstants.staffGroundStaff,
                AppConstants.staffEngineer,
                AppConstants.staffSecurity,
                AppConstants.staffManager,
              ].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.replaceAll('_', ' ')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedRole = value!);
              },
              validator: (value) =>
                  value == null ? 'Please select a role' : null,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _departmentController,
              labelText: 'Department',
              hintText: 'e.g., Flight Operations',
              prefixIcon: Icons.business_center,
              validator: (value) =>
                  Validators.validateRequired(value, 'Department'),
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Add Staff Member',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
              icon: Icons.person_add,
              width: double.infinity,
              height: 56,
            ),
          ],
        ),
      ),
    );
  }
}
