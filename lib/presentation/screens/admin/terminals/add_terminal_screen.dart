import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../providers/terminal_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class AddTerminalScreen extends StatefulWidget {
  @override
  State<AddTerminalScreen> createState() => _AddTerminalScreenState();
}

class _AddTerminalScreenState extends State<AddTerminalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _capacityController;
  late TextEditingController _facilitiesController;
  String _selectedStatus = 'OPERATIONAL';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _capacityController = TextEditingController();
    _facilitiesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _capacityController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

  Future<void> _addTerminal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final terminalData = {
        'name': _nameController.text.trim(),
        'code': _codeController.text.trim().toUpperCase(),
        'capacity': int.parse(_capacityController.text),
        'status': _selectedStatus,
        'facilities': _facilitiesController.text.trim(),
      };

      final success =
          await Provider.of<TerminalProvider>(context, listen: false)
              .createTerminal(terminalData);

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terminal added successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add terminal'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Terminal'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terminal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                labelText: 'Terminal Name *',
                hintText: 'e.g., Terminal 1',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Terminal name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _codeController,
                labelText: 'Terminal Code *',
                hintText: 'e.g., T1',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Terminal code is required';
                  }
                  if (value.trim().length > 10) {
                    return 'Code must be 10 characters or less';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _capacityController,
                labelText: 'Capacity *',
                hintText: 'e.g., 50',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Capacity is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Capacity must be greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Status *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'OPERATIONAL',
                    child: Text('Operational'),
                  ),
                  DropdownMenuItem(
                    value: 'MAINTENANCE',
                    child: Text('Maintenance'),
                  ),
                  DropdownMenuItem(
                    value: 'CLOSED',
                    child: Text('Closed'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _facilitiesController,
                labelText: 'Facilities (Optional)',
                hintText: 'e.g., WiFi, Food Court, Duty Free',
                maxLines: 3,
              ),
              SizedBox(height: 32),
              CustomButton(
                text: _isLoading ? 'Adding...' : 'Add Terminal',
                onPressed: _isLoading ? () {} : _addTerminal,
                width: double.infinity,
                height: 56,
              ),
              SizedBox(height: 16),
              Text(
                '* Required fields',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
