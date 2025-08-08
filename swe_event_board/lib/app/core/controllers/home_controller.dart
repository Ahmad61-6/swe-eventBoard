import 'package:get/get.dart';

import '../models/student_model.dart';
import '../services/profile_service.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find();
  final ProfileService _profileService = Get.find();
  // final EventService _eventService = Get.find();

  // final events = <Event>[].obs;
  final isLoading = true.obs;
  final student = Rxn<Student>();

  @override
  void onInit() {
    super.onInit();
    // loadEvents();
    fetchProfile();
  }

  // Future<void> loadEvents() async {
  //   try {
  //     isLoading(true);
  //     final eventsList = await _eventService.getUpcomingEvents();
  //     events.assignAll(eventsList);
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to load events: ${e.toString()}');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> fetchProfile() async {
    try {
      if (_authController.isLoggedIn.value) {
        student.value = await _profileService.getCurrentProfile();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    }
  }

  void logout() {
    _authController.signOut();
    Get.offAllNamed('/login');
  }
}
