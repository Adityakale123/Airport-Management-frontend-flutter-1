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



// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// import '../../../../core/constants/app_colors.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../widgets/common/custom_button.dart';
// import '../../../widgets/common/custom_text_field.dart';
// import '../../../../data/repositories/user_repository.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   final _aadharController = TextEditingController();
//   final _panController = TextEditingController();
//   final _passportController = TextEditingController();

//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() {
//     final user = Provider.of<AuthProvider>(context, listen: false).user;

//     if (user != null) {
//       _nameController.text = user.name;
//       _emailController.text = user.email;
//       _phoneController.text = user.phone ?? "";
//       _addressController.text = user.address ?? "";

//       _aadharController.text = user.aadharNumber ?? "";
//       _panController.text = user.panNumber ?? "";
//       _passportController.text = user.passportNumber ?? "";
//     }
//   }

//   // Convert UI label → backend key
//   String _mapDocType(String doc) {
//     switch (doc) {
//       case "Aadhar":
//         return "aadhar";
//       case "PAN":
//         return "pan";
//       case "Passport":
//         return "passport";
//       default:
//         return "";
//     }
//   }

//   // ------------------ UPLOAD ------------------
//   Future<void> _selectAndUpload(String docType) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         withData: true,
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
//       );

//       if (result == null) return;

//       final file = result.files.single;
//       final backendType = _mapDocType(docType);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Uploading ${file.name} ..."),
//           backgroundColor: AppColors.primary,
//         ),
//       );

//       final repo = UserRepository();

//       if (kIsWeb) {
//         await repo.uploadDocument(
//           backendType,
//           file.bytes!,
//           file.name,
//         );
//       } else {
//         await repo.uploadDocument(
//           backendType,
//           file.path!,
//           file.name,
//         );
//       }

//       await Provider.of<AuthProvider>(context, listen: false).refreshUser();

//       setState(() {});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("$docType Uploaded Successfully"),
//           backgroundColor: AppColors.success,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Upload Failed: $e"),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }

//   // ------------------ VIEW ------------------
//   Future<void> _viewDocument(String docType) async {
//     try {
//       setState(() => _isLoading = true);

//       final repo = UserRepository();
//       final backendType = _mapDocType(docType);

//       final url = await repo.getDocumentUrl(backendType);

//       setState(() => _isLoading = false);

//       if (url.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("No $docType uploaded"),
//             backgroundColor: AppColors.error,
//           ),
//         );
//         return;
//       }

//       // Open Preview Screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => DocumentPreviewScreen(documentUrl: url),
//         ),
//       );
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Unable to load document"),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }

//   // ------------------ SAVE PROFILE ------------------
//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final repo = UserRepository();
//     final updated = await repo.updateProfile({
//       "name": _nameController.text.trim(),
//       "email": _emailController.text.trim(),
//       "phone": _phoneController.text.trim(),
//       "address": _addressController.text.trim(),
//       "aadharNumber": _aadharController.text.trim(),
//       "panNumber": _panController.text.trim(),
//       "passportNumber": _passportController.text.trim(),
//     });

//     Provider.of<AuthProvider>(context, listen: false).setUser(updated);

//     setState(() {
//       _isEditing = false;
//       _isLoading = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Profile Updated Successfully"),
//         backgroundColor: AppColors.success,
//       ),
//     );
//   }

//   // --------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<AuthProvider>(context).user;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//         actions: [
//           IconButton(
//             icon: Icon(_isEditing ? Icons.close : Icons.edit),
//             onPressed: () => setState(() => _isEditing = !_isEditing),
//           )
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     CustomTextField(
//                       controller: _nameController,
//                       labelText: "Name",
//                       enabled: _isEditing,
//                     ),
//                     CustomTextField(
//                       controller: _emailController,
//                       labelText: "Email",
//                       enabled: false,
//                     ),
//                     CustomTextField(
//                       controller: _phoneController,
//                       labelText: "Phone",
//                       enabled: _isEditing,
//                     ),
//                     CustomTextField(
//                       controller: _addressController,
//                       labelText: "Address",
//                       enabled: _isEditing,
//                     ),
//                     SizedBox(height: 20),
//                     _buildDocumentWidget("Aadhar", _aadharController.text),
//                     _buildDocumentWidget("PAN", _panController.text),
//                     _buildDocumentWidget("Passport", _passportController.text),
//                     SizedBox(height: 20),
//                     if (_isEditing)
//                       CustomButton(
//                         text: "Save Profile",
//                         onPressed: _saveProfile,
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildDocumentWidget(String title, String number) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 14),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("$title Number"),
//             SizedBox(height: 6),
//             TextFormField(
//               controller: title == "Aadhar"
//                   ? _aadharController
//                   : title == "PAN"
//                       ? _panController
//                       : _passportController,
//               enabled: _isEditing,
//               decoration: InputDecoration(border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _selectAndUpload(title),
//                   child: Text("Upload"),
//                 ),
//                 SizedBox(width: 12),
//                 ElevatedButton(
//                   onPressed: () => _viewDocument(title),
//                   child: Text("View"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DocumentPreviewScreen extends StatelessWidget {
//   final String documentUrl;

//   const DocumentPreviewScreen({required this.documentUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Document Preview")),
//       body: Center(
//         child: Image.network(
//           documentUrl,
//           errorBuilder: (_, __, ___) => Text("Unable to preview document"),
//         ),
//       ),
//     );
//   }
// }



// // ==================== COMPLETE ProfileScreen with Web Support ====================
// // File: lib/presentation/screens/user/profile/profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/utils/validators.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../widgets/common/custom_button.dart';
// import '../../../widgets/common/custom_text_field.dart';
// import '../../../../data/repositories/user_repository.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
  
//   // Document controllers
//   final _aadharNumberController = TextEditingController();
//   final _panNumberController = TextEditingController();
//   final _passportNumberController = TextEditingController();

//   // File paths/names for selected documents
//   String? _selectedAadharPath;
//   String? _selectedPanPath;
//   String? _selectedPassportPath;

//   // Bytes for web platform
//   List<int>? _selectedAadharBytes;
//   List<int>? _selectedPanBytes;
//   List<int>? _selectedPassportBytes;

//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _aadharNumberController.dispose();
//     _panNumberController.dispose();
//     _passportNumberController.dispose();
//     super.dispose();
//   }

//   void _loadUserData() {
//     final user = Provider.of<AuthProvider>(context, listen: false).user;
//     if (user != null) {
//       _nameController.text = user.name;
//       _emailController.text = user.email;
//       _phoneController.text = user.phone ?? '';
//       _addressController.text = user.address ?? '';
//       _aadharNumberController.text = user.aadharNumber ?? '';
//       _panNumberController.text = user.panNumber ?? '';
//       _passportNumberController.text = user.passportNumber ?? '';
//     }
//   }

//   // Upload document file picker with web support
//   Future<void> _uploadDocument(String documentType) async {
//     try {
//       // Pick file (image or PDF)
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
//         withData: kIsWeb, // Load bytes for web
//       );

//       if (result != null) {
//         final fileName = result.files.single.name;
        
//         // Store file info based on platform
//         setState(() {
//           if (documentType.contains('Aadhar')) {
//             _selectedAadharPath = kIsWeb ? fileName : result.files.single.path!;
//             if (kIsWeb) _selectedAadharBytes = result.files.single.bytes;
//           } else if (documentType.contains('PAN')) {
//             _selectedPanPath = kIsWeb ? fileName : result.files.single.path!;
//             if (kIsWeb) _selectedPanBytes = result.files.single.bytes;
//           } else if (documentType.contains('Passport')) {
//             _selectedPassportPath = kIsWeb ? fileName : result.files.single.path!;
//             if (kIsWeb) _selectedPassportBytes = result.files.single.bytes;
//           }
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Expanded(child: Text('✓ $fileName selected')),
//               ],
//             ),
//             backgroundColor: AppColors.success,
//             duration: Duration(seconds: 2),
//           ),
//         );

//         // TODO: Uncomment when backend is ready
//         // if (kIsWeb) {
//         //   await _uploadBytesToBackend(result.files.single.bytes!, fileName, documentType);
//         // } else {
//         //   await _uploadFileToBackend(File(result.files.single.path!), documentType);
//         // }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to select file: $e'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }

//   // Get selected file path or name
//   String? _getSelectedPath(String documentType) {
//     if (documentType.contains('Aadhar')) return _selectedAadharPath;
//     if (documentType.contains('PAN')) return _selectedPanPath;
//     if (documentType.contains('Passport')) return _selectedPassportPath;
//     return null;
//   }

//   // Clear selected file
//   void _clearSelectedFile(String documentType) {
//     setState(() {
//       if (documentType.contains('Aadhar')) {
//         _selectedAadharPath = null;
//         _selectedAadharBytes = null;
//       } else if (documentType.contains('PAN')) {
//         _selectedPanPath = null;
//         _selectedPanBytes = null;
//       } else if (documentType.contains('Passport')) {
//         _selectedPassportPath = null;
//         _selectedPassportBytes = null;
//       }
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('File removed'),
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }

//   // Get file name for display
//   String _getFileName(String? path) {
//     if (path == null) return '';
//     if (kIsWeb) return path; // Already filename on web
//     return path.split('/').last; // Extract filename from path on mobile
//   }

//   // TODO: Upload bytes to backend (for web)
//   Future<void> _uploadBytesToBackend(List<int> bytes, String fileName, String documentType) async {
//     try {
//       setState(() => _isLoading = true);
      
//       // TODO: Implement multipart upload with bytes
//       // final userRepository = UserRepository();
//       // await userRepository.uploadDocumentBytes(bytes, fileName, documentType);
      
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('$documentType uploaded successfully'),
//             backgroundColor: AppColors.success,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Upload failed: $e'),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     }
//   }

//   // TODO: Upload file to backend (for mobile)
//   Future<void> _uploadFileToBackend(File file, String documentType) async {
//     try {
//       setState(() => _isLoading = true);
      
//       // TODO: Implement multipart upload with file
//       // final userRepository = UserRepository();
//       // await userRepository.uploadDocument(file, documentType);
      
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('$documentType uploaded successfully'),
//             backgroundColor: AppColors.success,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Upload failed: $e'),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _handleSave() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final authProvider = context.read<AuthProvider>();
      
//       final profileData = {
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'address': _addressController.text.trim(),
//         'aadharNumber': _aadharNumberController.text.trim(),
//         'panNumber': _panNumberController.text.trim(),
//         'passportNumber': _passportNumberController.text.trim(),
//       };

//       final success = await authProvider.updateProfile(profileData);

//       if (success && mounted) {
//         setState(() {
//           _isLoading = false;
//           _isEditing = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile updated successfully'),
//             backgroundColor: AppColors.success,
//           ),
//         );
//       } else {
//         throw Exception('Failed to update profile');
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update profile: $e'),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile'),
//         actions: [
//           if (!_isEditing)
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => setState(() => _isEditing = true),
//             ),
//         ],
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           final user = authProvider.user;

//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Profile Header
//                 Container(
//                   padding: EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.primary, AppColors.primaryDark],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.white,
//                         child: Text(
//                           user?.name.substring(0, 1).toUpperCase() ?? 'U',
//                           style: TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         user?.name ?? 'User',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           user?.role ?? 'USER',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 SizedBox(height: 24),
                
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Personal Information
//                       Text(
//                         'Personal Information',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _nameController,
//                         labelText: 'Full Name',
//                         prefixIcon: Icons.person,
//                         enabled: _isEditing,
//                         validator: Validators.validateName,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _emailController,
//                         labelText: 'Email',
//                         prefixIcon: Icons.email,
//                         enabled: false,
//                         validator: Validators.validateEmail,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _phoneController,
//                         labelText: 'Phone',
//                         prefixIcon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                         enabled: _isEditing,
//                         validator: Validators.validatePhone,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _addressController,
//                         labelText: 'Address',
//                         prefixIcon: Icons.location_on,
//                         enabled: _isEditing,
//                         maxLines: 2,
//                       ),
                      
//                       SizedBox(height: 24),
                      
//                       // Document Information Section
//                       Text(
//                         'Document Information',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 16),
                      
//                       // Aadhar Card
//                       _buildDocumentCard(
//                         icon: Icons.credit_card,
//                         title: 'Aadhar Card',
//                         numberController: _aadharNumberController,
//                         photoUrl: user?.aadharPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       SizedBox(height: 16),
                      
//                       // PAN Card
//                       _buildDocumentCard(
//                         icon: Icons.badge,
//                         title: 'PAN Card',
//                         numberController: _panNumberController,
//                         photoUrl: user?.panPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       SizedBox(height: 16),
                      
//                       // Passport
//                       _buildDocumentCard(
//                         icon: Icons.book,
//                         title: 'Passport',
//                         numberController: _passportNumberController,
//                         photoUrl: user?.passportPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       if (_isEditing) ...[
//                         SizedBox(height: 24),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Cancel',
//                                 onPressed: () {
//                                   setState(() => _isEditing = false);
//                                   _loadUserData();
//                                 },
//                                 isOutlined: true,
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Save',
//                                 onPressed: _handleSave,
//                                 isLoading: _isLoading,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
                
//                 SizedBox(height: 24),
                
//                 // Account Settings
//                 Text(
//                   'Account Settings',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 _buildSettingCard(
//                   icon: Icons.lock,
//                   title: 'Change Password',
//                   subtitle: 'Update your password',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Change password')),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.notifications,
//                   title: 'Notifications',
//                   subtitle: 'Manage notification preferences',
//                   onTap: () {
//                     Navigator.pushNamed(context, AppRoutes.settings);
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.security,
//                   title: 'Privacy & Security',
//                   subtitle: 'Manage your privacy settings',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Privacy settings')),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.help,
//                   title: 'Help & Support',
//                   subtitle: 'Get help and contact support',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Help & support')),
//                     );
//                   },
//                 ),
                
//                 SizedBox(height: 24),
                
//                 CustomButton(
//                   text: 'Logout',
//                   onPressed: () async {
//                     final confirmed = await showDialog<bool>(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text('Logout'),
//                         content: Text('Are you sure you want to logout?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.error,
//                             ),
//                             child: Text('Logout'),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirmed == true) {
//                       await authProvider.logout();
//                       Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         AppRoutes.login,
//                         (route) => false,
//                       );
//                     }
//                   },
//                   backgroundColor: AppColors.error,
//                   icon: Icons.logout,
//                   width: double.infinity,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDocumentCard({
//     required IconData icon,
//     required String title,
//     required TextEditingController numberController,
//     String? photoUrl,
//     required bool enabled,
//   }) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: AppColors.primary),
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             CustomTextField(
//               controller: numberController,
//               labelText: '$title Number',
//               prefixIcon: Icons.numbers,
//               enabled: enabled,
//               keyboardType: TextInputType.text,
//             ),
            
//             // If document is uploaded on backend
//             if (photoUrl != null && photoUrl.isNotEmpty) ...[
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(Icons.check_circle, color: AppColors.success, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     'Document uploaded',
//                     style: TextStyle(
//                       color: AppColors.success,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Spacer(),
//                   TextButton.icon(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('View document: $photoUrl')),
//                       );
//                     },
//                     icon: Icon(Icons.visibility, size: 16),
//                     label: Text('View'),
//                   ),
//                 ],
//               ),
//             ] else if (enabled) ...[
//               SizedBox(height: 12),
              
//               // Show selected file preview if exists
//               if (_getSelectedPath(title) != null) ...[
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.insert_drive_file, size: 20, color: AppColors.primary),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Selected File:',
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                             SizedBox(height: 2),
//                             Text(
//                               _getFileName(_getSelectedPath(title)),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, size: 18, color: AppColors.error),
//                         onPressed: () => _clearSelectedFile(title),
//                         tooltip: 'Remove file',
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//               ],
              
//               // Upload/Change button
//               OutlinedButton.icon(
//                 onPressed: () => _uploadDocument(title),
//                 icon: Icon(_getSelectedPath(title) != null ? Icons.change_circle : Icons.upload_file),
//                 label: Text(_getSelectedPath(title) != null ? 'Change File' : 'Upload $title'),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: AppColors.primary,
//                   side: BorderSide(color: AppColors.primary),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       child: ListTile(
//         leading: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: AppColors.primary),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(fontSize: 12),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }


// // ==================== UPDATED ProfileScreen with Document Fields ====================
// // File: lib/presentation/screens/user/profile/profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/utils/validators.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../widgets/common/custom_button.dart';
// import '../../../widgets/common/custom_text_field.dart';
// import '../../../../data/repositories/user_repository.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
  
 
//   final _aadharNumberController = TextEditingController();
//   final _panNumberController = TextEditingController();
//   final _passportNumberController = TextEditingController();

//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _aadharNumberController.dispose();
//     _panNumberController.dispose();
//     _passportNumberController.dispose();
//     super.dispose();
//   }

//   void _loadUserData() {
//     final user = Provider.of<AuthProvider>(context, listen: false).user;
//     if (user != null) {
//       _nameController.text = user.name;
//       _emailController.text = user.email;
//       _phoneController.text = user.phone ?? '';
//       _addressController.text = user.address ?? '';
//       _aadharNumberController.text = user.aadharNumber ?? '';
//       _panNumberController.text = user.panNumber ?? '';
//       _passportNumberController.text = user.passportNumber ?? '';
//     }
//   }

//   Future<void> _handleSave() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final authProvider = context.read<AuthProvider>();
      
//       final profileData = {
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'address': _addressController.text.trim(),
//         'aadharNumber': _aadharNumberController.text.trim(),
//         'panNumber': _panNumberController.text.trim(),
//         'passportNumber': _passportNumberController.text.trim(),
//       };

//       final success = await authProvider.updateProfile(profileData);

//       if (success && mounted) {
//         setState(() {
//           _isLoading = false;
//           _isEditing = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile updated successfully'),
//             backgroundColor: AppColors.success,
//           ),
//         );
//       } else {
//         throw Exception('Failed to update profile');
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update profile: $e'),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile'),
//         actions: [
//           if (!_isEditing)
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () => setState(() => _isEditing = true),
//             ),
//         ],
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           final user = authProvider.user;

//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Profile Header
//                 Container(
//                   padding: EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.primary, AppColors.primaryDark],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.white,
//                         child: Text(
//                           user?.name.substring(0, 1).toUpperCase() ?? 'U',
//                           style: TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         user?.name ?? 'User',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           user?.role ?? 'USER',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 SizedBox(height: 24),
                
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Personal Information
//                       Text(
//                         'Personal Information',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _nameController,
//                         labelText: 'Full Name',
//                         prefixIcon: Icons.person,
//                         enabled: _isEditing,
//                         validator: Validators.validateName,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _emailController,
//                         labelText: 'Email',
//                         prefixIcon: Icons.email,
//                         enabled: false,
//                         validator: Validators.validateEmail,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _phoneController,
//                         labelText: 'Phone',
//                         prefixIcon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                         enabled: _isEditing,
//                         validator: Validators.validatePhone,
//                       ),
//                       SizedBox(height: 16),
//                       CustomTextField(
//                         controller: _addressController,
//                         labelText: 'Address',
//                         prefixIcon: Icons.location_on,
//                         enabled: _isEditing,
//                         maxLines: 2,
//                       ),
                      
//                       SizedBox(height: 24),
                      
//                       // ✅ Document Information Section
//                       Text(
//                         'Document Information',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 16),
                      
//                       // Aadhar Card
//                       _buildDocumentCard(
//                         icon: Icons.credit_card,
//                         title: 'Aadhar Card',
//                         numberController: _aadharNumberController,
//                         photoUrl: user?.aadharPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       SizedBox(height: 16),
                      
//                       // PAN Card
//                       _buildDocumentCard(
//                         icon: Icons.badge,
//                         title: 'PAN Card',
//                         numberController: _panNumberController,
//                         photoUrl: user?.panPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       SizedBox(height: 16),
                      
//                       // Passport
//                       _buildDocumentCard(
//                         icon: Icons.book,
//                         title: 'Passport',
//                         numberController: _passportNumberController,
//                         photoUrl: user?.passportPhotoUrl,
//                         enabled: _isEditing,
//                       ),
                      
//                       if (_isEditing) ...[
//                         SizedBox(height: 24),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Cancel',
//                                 onPressed: () {
//                                   setState(() => _isEditing = false);
//                                   _loadUserData();
//                                 },
//                                 isOutlined: true,
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Expanded(
//                               child: CustomButton(
//                                 text: 'Save',
//                                 onPressed: _handleSave,
//                                 isLoading: _isLoading,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
                
//                 SizedBox(height: 24),
                
//                 // Account Settings
//                 Text(
//                   'Account Settings',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 _buildSettingCard(
//                   icon: Icons.lock,
//                   title: 'Change Password',
//                   subtitle: 'Update your password',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Change password')),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.notifications,
//                   title: 'Notifications',
//                   subtitle: 'Manage notification preferences',
//                   onTap: () {
//                     Navigator.pushNamed(context, AppRoutes.settings);
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.security,
//                   title: 'Privacy & Security',
//                   subtitle: 'Manage your privacy settings',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Privacy settings')),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 _buildSettingCard(
//                   icon: Icons.help,
//                   title: 'Help & Support',
//                   subtitle: 'Get help and contact support',
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Help & support')),
//                     );
//                   },
//                 ),
                
//                 SizedBox(height: 24),
                
//                 CustomButton(
//                   text: 'Logout',
//                   onPressed: () async {
//                     final confirmed = await showDialog<bool>(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text('Logout'),
//                         content: Text('Are you sure you want to logout?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(context, true),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.error,
//                             ),
//                             child: Text('Logout'),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirmed == true) {
//                       await authProvider.logout();
//                       Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         AppRoutes.login,
//                         (route) => false,
//                       );
//                     }
//                   },
//                   backgroundColor: AppColors.error,
//                   icon: Icons.logout,
//                   width: double.infinity,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

 
//   Widget _buildDocumentCard({
//     required IconData icon,
//     required String title,
//     required TextEditingController numberController,
//     String? photoUrl,
//     required bool enabled,
//   }) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: AppColors.primary),
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             CustomTextField(
//               controller: numberController,
//               labelText: '$title Number',
//               prefixIcon: Icons.numbers,
//               enabled: enabled,
//               keyboardType: TextInputType.text,
//             ),
//             if (photoUrl != null && photoUrl.isNotEmpty) ...[
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(Icons.check_circle, color: AppColors.success, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     'Document uploaded',
//                     style: TextStyle(
//                       color: AppColors.success,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Spacer(),
//                   TextButton.icon(
//                     onPressed: () {
                    
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('View document: $photoUrl')),
//                       );
//                     },
//                     icon: Icon(Icons.visibility, size: 16),
//                     label: Text('View'),
//                   ),
//                 ],
//               ),
//             ] else if (enabled) ...[
//               SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: () {
//                   // Upload document
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Upload $title')),
//                   );
//                 },
//                 icon: Icon(Icons.upload_file),
//                 label: Text('Upload $title'),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: AppColors.primary,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       child: ListTile(
//         leading: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: AppColors.primary),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(fontSize: 12),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }

