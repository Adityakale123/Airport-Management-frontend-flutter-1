import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/user.dart';
import '../../core/constants/api_endpoints.dart';

class UserRepository {
  // Fetch profile
  Future<User> getProfile() async {
    try {
      final response = await ApiService.get(ApiEndpoints.userProfile);
      final user = User.fromJson(response);
      await LocalStorageService.saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<User> updateProfile(Map<String, dynamic> profileData) async {
    try {
      print('Sending profile data: $profileData');

      final response = await ApiService.put(
        ApiEndpoints.updateProfile,
        profileData,
      );

      print('Profile update response: $response');

      final user = User.fromJson(response);
      await LocalStorageService.saveUser(user);
      return user;
    } catch (e) {
      print('Profile update error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Detect MIME type
  MediaType _detectMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  // Upload document (mobile + web)
  Future<User> uploadDocument(
      String documentType, dynamic fileData, String fileName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}${ApiEndpoints.uploadDocument}'),
      );

      // JWT Token
      final token = await LocalStorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['documentType'] = documentType;
      final mimeType = _detectMimeType(fileName);

      if (kIsWeb) {
        // Web: fileData = List<int>
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileData as List<int>,
            filename: fileName,
            contentType: mimeType,
          ),
        );
      } else {
        // Mobile: fileData = File path
        final file = File(fileData);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: fileName,
            contentType: mimeType,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        await LocalStorageService.saveUser(user);
        return user;
      } else {
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<String> getDocumentUrl(String documentType) async {
    try {
      final response = await ApiService.get(
        "${ApiEndpoints.getDocument}/$documentType",
      );

      return response['url'];
    } catch (e) {
      throw Exception('Failed to get document URL: $e');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await ApiService.post(ApiEndpoints.changePassword, {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
