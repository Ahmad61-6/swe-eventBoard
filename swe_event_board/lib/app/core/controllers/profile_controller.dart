import 'package:get/get.dart';

import '../models/student_model.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = Get.find();
  final Rx<Student?> student = Rx<Student?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      student.value = await _profileService.getCurrentProfile();
    } catch (e) {
      error('Failed to load profile: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      isLoading(true);
      final userId = student.value?.id;
      if (userId == null) return;

      final imageUrl = await _profileService.uploadProfileImage(userId);
      student.update((val) {
        if (val != null) val.profilePicUrl = imageUrl;
      });
    } catch (e) {
      error('Failed to update profile picture: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateBasicInfo({
    required String firstName,
    required String lastName,
    String? studentId,
    String? department,
  }) async {
    try {
      isLoading(true);
      final updatedProfile = await _profileService.updateBasicInfo(
        firstName: firstName,
        lastName: lastName,
        studentId: studentId,
        department: department,
      );
      student.value = updatedProfile;
    } catch (e) {
      error('Failed to update profile: $e');
    } finally {
      isLoading(false);
    }
  }
}
