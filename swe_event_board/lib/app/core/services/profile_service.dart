import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../models/student_model.dart';
import 'storage_service.dart';

class ProfileService {
  final ProfileRepository _profileRepo = Get.find();
  final StorageService _storageService = Get.find();
  final ImagePicker _picker = ImagePicker();

  Future<Student> getProfile(String userId) async {
    return await _profileRepo.getProfile(userId);
  }

  Future<Student> updateProfile(Student student) async {
    return await _profileRepo.updateProfile(student);
  }

  // Upload profile picture and update URL
  Future<String> uploadProfileImage(String userId) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (image == null) throw Exception('No image selected');

      final File imageFile = File(image.path);
      final imageUrl = await _storageService.uploadAvatar(userId, imageFile);
      await _profileRepo.updateProfilePictureUrl(userId, imageUrl);

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Get current student profile
  Future<Student> getCurrentProfile() async {
    final userId = Get.find<AuthRepository>().currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    return await getProfile(userId);
  }

  // Update basic profile info
  Future<Student> updateBasicInfo({
    required String firstName,
    required String lastName,
    String? studentId,
    String? department,
  }) async {
    final userId = Get.find<AuthRepository>().currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final currentProfile = await getProfile(userId);
    final updatedProfile = currentProfile.copyWith(
      firstName: firstName,
      lastName: lastName,
      studentId: studentId,
      department: department,
    );

    return await updateProfile(updatedProfile);
  }
}
