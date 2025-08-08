import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late SupabaseClient _supabase;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _supabase = Get.find<SupabaseClient>();

    return this;
  }

  Future<String> uploadAvatar(String userId, File image) async {
    try {
      final fileExt = image.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExt';
      final filePath = '$userId/$fileName';

      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            image,
            fileOptions: FileOptions(
              contentType: 'image/$fileExt',
              upsert: true,
            ),
          );

      return _supabase.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  // Save user session
  Future<void> saveSession(String userId) async {
    await _prefs.setString('user_id', userId);
    await _prefs.setBool('is_logged_in', true);
  }

  // Clear session on logout
  Future<void> clearSession() async {
    await _prefs.remove('user_id');
    await _prefs.setBool('is_logged_in', false);
  }

  // Get user ID from session
  Future<String?> getUserId() async {
    return _prefs.getString('user_id');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _prefs.getBool('is_logged_in') ?? false;
  }
}
