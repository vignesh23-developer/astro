import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/a_video_controller.dart';
import '../../model/admin_video_model.dart';
import 'a_videofullview.dart';
import 'admin_login_view.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final controller = Get.put(AdminVideoController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF6A5AE0),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showLogoutDialog();
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
          title: const Text(
            "Admin Videos",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 36,
              indicatorColor: Colors.white,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            labelColor: Color(0xFF6A5AE0),
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Free"),
              Tab(text: "Entry"),
              Tab(text: "Advance"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            videoList(controller.freeVideos, isFree: true),
            videoList(controller.entryVideos, isFree: false),
            videoList(controller.advanceVideos, isFree: false),
          ],
        ),
      ),
    );
  }

  Widget videoList(RxList<VideoModel> list, {required bool isFree}) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          // Call the API to refresh videos
          await controller
              .fetchVideos(); // Make sure this method exists in your controller
        },
        child: list.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text("No Videos")),
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final video = list[index];
                  return GestureDetector(
                    onTap: () => playVideo(video.videoUrl),
                    child: buildVideoCard(video: video, isFree: isFree),
                  );
                },
              ),
      );
    });
  }

  Widget buildVideoCard({required VideoModel video, required bool isFree}) {
    return Stack(
      children: [
        // 🔹 Main Card with shadow & rounded corners
        GestureDetector(
          onTap: () => playVideo(video.videoUrl),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // 🔹 Background image
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/ALogo/play_image.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 🔹 Glass/Blur effect overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // 🔹 Video title & type
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 80,
                    child: Text(
                      video.type[0].toUpperCase() + video.type.substring(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 FREE Badge
                  if (isFree)
                    Positioned(
                      top: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          "FREE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                  // 🔹 Play Button (centered bottom-right)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 🔹 Delete button overlay (top-left)
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: () async {
              final controller = Get.find<AdminVideoController>();
              bool confirmed = await showDialog(
                context: Get.context!,
                builder: (ctx) => AlertDialog(
                  title: const Text("Delete Video"),
                  content: const Text(
                    "Are you sure you want to delete this video?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed) {
                await controller.deleteVideo(video.id);
                Get.snackbar(
                  "Deleted",
                  "Video has been deleted successfully",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.85),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void playVideo(String url) {
    Get.to(() => VideoFullScreenPage(videoUrl: url));
  }
  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: 50,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 15),

              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(() => AdminLoginView());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
