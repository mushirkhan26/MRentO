import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

extension SecureStorageExtensions on BuildContext {
  /// Get current user's ID
  Future<String?> getCurrentUserId() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['userId'];
  }

  /// Get current user's name (username)
  Future<String?> getCurrentUsername() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['name'];
  }

  /// Get all user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    return await SecureStorageService().getUserData();
  }

  /// Get current user's email
  Future<String?> getCurrentUserEmail() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['email'];
  }

  /// Get current user's role
  Future<String?> getCurrentUserRole() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['role'];
  }
}