import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../providers/staff_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class AddStaffScreen extends StatefulWidget {
  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _hireDateController;
  late TextEditingController _departmentController;
  late TextEditingController _salaryController;
  late TextEditingController _terminalIdController;

  String _selectedRole = 'GROUND_STAFF';
  String _selectedStatus = 'ACTIVE';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _hireDateController = TextEditingController();
    _departmentController = TextEditingController();
    _salaryController = TextEditingController();
    _terminalIdController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hireDateController.dispose();
    _departmentController.dispose();
    _salaryController.dispose();
    _terminalIdController.dispose();
    super.dispose();
  }

  Future<void> _selectHireDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _hireDateController.text = date.toString().split(' ')[0];
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final staffData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': _selectedRole,
        'hireDate': _hireDateController.text,
        'department': _departmentController.text,
        'salary': double.tryParse(_salaryController.text) ?? 0.0,
        'status': _selectedStatus,
        'terminalId': int.tryParse(_terminalIdController.text),
      };

      final success = await Provider.of<StaffProvider>(context, listen: false)
          .createStaff(staffData);

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Staff member added successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add staff member')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Staff Member'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name *',
                hintText: 'Enter first name',
                validator: (value) =>
                    Validators.validateRequired(value, 'First Name'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name *',
                hintText: 'Enter last name',
                validator: (value) =>
                    Validators.validateRequired(value, 'Last Name'),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email *',
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone *',
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 20),

              const Text(
                'Employment Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role *',
                  prefixIcon: const Icon(Icons.work),
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
                  'PILOT',
                  'CABIN_CREW',
                  'GROUND_STAFF',
                  'ENGINEER',
                  'SECURITY',
                  'MANAGER',
                ].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.replaceAll('_', ' ')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectHireDate,
                child: CustomTextField(
                  controller: _hireDateController,
                  labelText: 'Hire Date *',
                  hintText: 'YYYY-MM-DD',
                  enabled: false,
                  validator: (value) =>
                      Validators.validateRequired(value, 'Hire Date'),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _departmentController,
                labelText: 'Department',
                hintText: 'e.g., Flight Operations',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _salaryController,
                labelText: 'Salary',
                hintText: 'e.g., 50000',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              const Text(
                'Additional Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(Icons.info),
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
                items: ['ACTIVE', 'INACTIVE', 'ON_LEAVE'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _terminalIdController,
                labelText: 'Terminal ID',
                hintText: 'e.g., 1',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: _isLoading ? 'Adding...' : 'Add Staff Member',
                onPressed: _isLoading ? () {} : _handleSubmit,
                width: double.infinity,
                height: 56,
              ),
              const SizedBox(height: 16),
              Text(
                '* Required fields',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
