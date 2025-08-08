import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/student_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Get.find();

  // Get student profile by user ID
  Future<Student> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('students')
          .select()
          .eq('id', userId)
          .single();
      return Student.fromMap(response);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // Update student profile
  Future<Student> updateProfile(Student student) async {
    try {
      final response = await _supabase
          .from('students')
          .update(student.toMap())
          .eq('id', student.id);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      // Return updated profile
      return await getProfile(student.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Update profile picture URL
  Future<void> updateProfilePictureUrl(String userId, String imageUrl) async {
    try {
      final response = await _supabase
          .from('students')
          .update({'profile_pic_url': imageUrl})
          .eq('id', userId);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}
