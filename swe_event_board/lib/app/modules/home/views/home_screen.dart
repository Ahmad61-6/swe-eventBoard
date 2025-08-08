// lib/app/modules/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/home_controller.dart';
import '../../../core/utils/animations.dart';
import '../../widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.find<HomeController>();
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
      duration: const Duration(milliseconds: 1200),
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
      appBar: CustomAppBar(title: 'SWE Events'),
      // body: RefreshIndicator(
      //   onRefresh: () => controller.loadEvents(),
      //   child: Obx(() {
      //     if (controller.isLoading.value) {
      //       return ShimmerLoading(
      //         child: ListView.builder(
      //           itemCount: 5,
      //           itemBuilder: (context, index) => EventCardShimmer(),
      //         ),
      //       );
      //     }
      //
      //     if (controller.events.isEmpty) {
      //       return FadeTransition(
      //         opacity: _fadeAnimation,
      //         child: Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               AppAnimations.scaleAnimation(
      //                 delay: 0.3,
      //                 child: Icon(Icons.event, size: 60, color: Colors.grey),
      //               ),
      //               const SizedBox(height: 20),
      //               AppAnimations.fadeSlideAnimation(
      //                 delay: 0.5,
      //                 child: Text(
      //                   'No events available',
      //                   style: Theme.of(context).textTheme.titleMedium,
      //                 ),
      //               ),
      //               const SizedBox(height: 10),
      //               AppAnimations.fadeSlideAnimation(
      //                 delay: 0.7,
      //                 child: Text(
      //                   'Check back later or create a new event',
      //                   style: Theme.of(context).textTheme.bodyMedium,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     }
      //
      //     return ListView.builder(
      //       itemCount: controller.events.length,
      //       itemBuilder: (context, index) {
      //         final event = controller.events[index];
      //         return AppAnimations.fadeSlideAnimation(
      //           delay: 0.2 * index,
      //           child: EventCard(event: event),
      //         );
      //       },
      //     );
      //   }),
      // ),
      floatingActionButton: AppAnimations.scaleAnimation(
        delay: 0.3,
        child: FloatingActionButton(
          onPressed: () => Get.toNamed('/create-event'),
          child: const Icon(Icons.add),
        ),
      ),
      drawer: Drawer(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(() {
                final student = controller.student.value;
                return AppAnimations.fadeSlideAnimation(
                  delay: 0.3,
                  child: UserAccountsDrawerHeader(
                    accountName: Text(student?.firstName ?? 'Guest'),
                    accountEmail: Text(student?.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: student?.profilePicUrl != null
                          ? NetworkImage(student!.profilePicUrl!)
                          : null,
                      child: student?.profilePicUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }),
              _buildAnimatedDrawerItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  Get.back();
                  Get.offNamed('/home');
                },
                delay: 0.4,
              ),
              _buildAnimatedDrawerItem(
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  Get.back();
                  Get.toNamed('/profile');
                },
                delay: 0.5,
              ),
              _buildAnimatedDrawerItem(
                icon: Icons.event,
                title: 'My Events',
                onTap: () => Get.toNamed('/my-events'),
                delay: 0.6,
              ),
              const Divider(),
              _buildAnimatedDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => controller.logout(),
                delay: 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double delay,
  }) {
    return AppAnimations.fadeSlideAnimation(
      delay: delay,
      child: ListTile(leading: Icon(icon), title: Text(title), onTap: onTap),
    );
  }
}
