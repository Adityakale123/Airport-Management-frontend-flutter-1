// ==================== COMPLETE ProfileScreen.dart ====================
// File: lib/presentation/screens/user/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../../data/repositories/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  final _passportController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? "";
      _addressController.text = user.address ?? "";

      _aadharController.text = user.aadharNumber ?? "";
      _panController.text = user.panNumber ?? "";
      _passportController.text = user.passportNumber ?? "";
    }
  }

  // Convert UI label → backend key
  String _mapDocType(String doc) {
    switch (doc) {
      case "Aadhar":
        return "AADHAR";
      case "PAN":
        return "PAN";
      case "Passport":
        return "PASSPORT";
      default:
        return "";
    }
  }

  // ------------------ UPLOAD ------------------
  Future<void> _selectAndUpload(String docType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result == null) return;

      final file = result.files.single;
      final backendType = _mapDocType(docType);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploading ${file.name} ..."),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );

      final repo = UserRepository();

      if (kIsWeb) {
        await repo.uploadDocument(
          backendType,
          file.bytes!,
          file.name,
        );
      } else {
        await repo.uploadDocument(
          backendType,
          file.path!,
          file.name,
        );
      }

      // Refresh user data
      await Provider.of<AuthProvider>(context, listen: false).refreshUser();

      if (mounted) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$docType Uploaded Successfully"),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload Failed: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // ------------------ VIEW ------------------
  Future<void> _viewDocument(String docType) async {
    try {
      setState(() => _isLoading = true);

      final repo = UserRepository();
      final backendType = _mapDocType(docType);

      final url = await repo.getDocumentUrl(backendType);

      setState(() => _isLoading = false);

      if (url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No $docType uploaded"),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Open Preview Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentPreviewScreen(documentUrl: url),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to load document: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ------------------ SAVE PROFILE ------------------
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Debug logs
      print('Email value: ${_emailController.text}');
      print('Name value: ${_nameController.text}');

      final repo = UserRepository();
      final updated = await repo.updateProfile({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "address": _addressController.text.trim(),
        "aadharNumber": _aadharController.text.trim(),
        "panNumber": _panController.text.trim(),
        "passportNumber": _passportController.text.trim(),
      });

      // Update auth provider
      Provider.of<AuthProvider>(context, listen: false).updateUser(updated);

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // --------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _loadUserData(); // Reload data on cancel
                }
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text("Loading..."),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              user?.name.substring(0, 1).toUpperCase() ?? 'U',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            user?.name ?? 'User',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user?.role ?? 'USER',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Personal Information
                    Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    CustomTextField(
                      controller: _nameController,
                      labelText: "Full Name",
                      prefixIcon: Icons.person,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      enabled: false,
                    ),
                    SizedBox(height: 16),

                    CustomTextField(
                      controller: _phoneController,
                      labelText: "Phone",
                      prefixIcon: Icons.phone,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: 16),

                    CustomTextField(
                      controller: _addressController,
                      labelText: "Address",
                      prefixIcon: Icons.location_on,
                      enabled: _isEditing,
                      maxLines: 2,
                    ),

                    SizedBox(height: 32),

                    // Document Information
                    Text(
                      "Document Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildDocumentWidget("Aadhar", _aadharController),
                    SizedBox(height: 16),
                    _buildDocumentWidget("PAN", _panController),
                    SizedBox(height: 16),
                    _buildDocumentWidget("Passport", _passportController),

                    SizedBox(height: 32),

                    // Save Button
                    if (_isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Cancel",
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _loadUserData();
                                });
                              },
                              isOutlined: true,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: "Save Profile",
                              onPressed: _saveProfile,
                              isLoading: _isLoading,
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

  Widget _buildDocumentWidget(String title, TextEditingController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title == "Aadhar"
                      ? Icons.credit_card
                      : title == "PAN"
                          ? Icons.badge
                          : Icons.book,
                  color: AppColors.primary,
                ),
                SizedBox(width: 12),
                Text(
                  "$title Card",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            CustomTextField(
              controller: controller,
              labelText: "$title Number",
              prefixIcon: Icons.numbers,
              enabled: _isEditing,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectAndUpload(title),
                    icon: Icon(Icons.upload_file, size: 18),
                    label: Text("Upload"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewDocument(title),
                    icon: Icon(Icons.visibility, size: 18),
                    label: Text("View"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ==================== Document Preview Screen ====================
class DocumentPreviewScreen extends StatelessWidget {
  final String documentUrl;

  const DocumentPreviewScreen({required this.documentUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document Preview"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: documentUrl.toLowerCase().endsWith('.pdf')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "PDF documents cannot be previewed",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Document URL: $documentUrl",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : Image.network(
                documentUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
                errorBuilder: (_, __, ___) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      "Unable to preview document",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
