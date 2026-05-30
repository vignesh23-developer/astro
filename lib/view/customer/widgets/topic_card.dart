import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../controller/video_controller.dart';
import '../../../model/topic_model.dart';
import '../video_player_view.dart';

class TopicCard extends StatefulWidget {
  final Topic topic;
  final int index;
  final AnimationController animationController;
  final List<String> videos;

  const TopicCard({
    super.key,
    required this.topic,
    required this.index,
    required this.animationController,
    required this.videos,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delay = widget.index * 0.1;
    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(delay, 1.0, curve: Curves.easeOutBack),
      ),
    );

    return AnimatedBuilder(
      animation: cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: cardAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _cardController.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _cardController.reverse();
            },
            child: GestureDetector(
              onTap: () {
                _showTopicDetails(context);
              },
              child: AnimatedBuilder(
                animation: _cardController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_cardController.value * 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: widget.topic.gradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10 * _cardController.value),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Opacity(
                              opacity: 0.1,
                              child: Text(
                                widget.topic.emoji,
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        widget.topic.icon,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      widget.topic.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.topic.description,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 11.sp,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.menu_book_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          '${widget.topic.lessons} lesson${widget.topic.lessons > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Explore button
                                Container(
                                  width: double.infinity,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Explore',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Hover overlay
                          if (_isHovered)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTopicDetails(BuildContext context) {
    final VideoController videoController = Get.find<VideoController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 500.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: widget.topic.gradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.topic.icon, color: Colors.white),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.topic.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.topic.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.videos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.back(); // Close bottom sheet

                            Get.to(() => VideoPlayerView(
                              urls: widget.videos,
                              startIndex: index, // 🔥 IMPORTANT FIX
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: widget.topic.gradient.colors[0]
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lesson ${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        '15 min • Beginner',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    height: 25.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.videos.isNotEmpty) {
                          Get.back();
                          Get.to(() => VideoPlayerView(
                            urls: widget.videos,
                            startIndex: 0,
                          ));
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.topic.gradient.colors[0],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Start Learning',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class Topic {
  final String title;
  final String description;
  final int lessons;
  final IconData icon;
  final LinearGradient gradient;
  final String emoji;

  Topic({
    required this.title,
    required this.description,
    required this.lessons,
    required this.icon,
    required this.gradient,
    required this.emoji,
  });
}