// lib/app/modules/profile/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/profile_controller.dart';
import '../../../core/models/student_model.dart';
import '../../../core/utils/animations.dart';
import '../../widgets/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController controller = Get.find<ProfileController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final student = controller.student.value;
        if (student == null) {
          return Center(child: Text('Profile not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                AppAnimations.scaleAnimation(
                  delay: 0.3,
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: student.profilePicUrl != null
                              ? NetworkImage(student.profilePicUrl!)
                              : null,
                          child: student.profilePicUrl == null
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: controller.updateProfilePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppAnimations.fadeSlideAnimation(
                  delay: 0.5,
                  child: Text(
                    student.firstName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                AppAnimations.fadeSlideAnimation(
                  delay: 0.6,
                  child: Text(
                    student.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 30),
                AppAnimations.fadeSlideAnimation(
                  delay: 0.7,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Student ID'),
                      subtitle: Text(student.studentId ?? 'Not set'),
                    ),
                  ),
                ),
                AppAnimations.fadeSlideAnimation(
                  delay: 0.8,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text('Department'),
                      subtitle: Text(student.department ?? 'Not set'),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AppAnimations.fadeSlideAnimation(
                  delay: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppAnimations.pulseAnimation(
                      child: ElevatedButton(
                        onPressed: () =>
                            _showEditProfileDialog(context, student),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.error.value.isNotEmpty) {
                    return AppAnimations.fadeSlideAnimation(
                      delay: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          controller.error.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showEditProfileDialog(BuildContext context, Student student) {
    final firstNameController = TextEditingController(text: student.firstName);
    final lastNameController = TextEditingController(text: student.lastName);
    final studentIdController = TextEditingController(text: student.studentId);
    final departmentController = TextEditingController(
      text: student.department,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: studentIdController,
                decoration: const InputDecoration(labelText: 'Student ID'),
              ),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateBasicInfo(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                studentId: studentIdController.text,
                department: departmentController.text,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
