import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import '../../app_constants.dart';
import '../../controller/video_controller.dart';
import '../../routes/SessionManger.dart';
import '../service/razorpay_service.dart';
import 'astro_pages/birth_details_form_screen.dart';
import 'jodhidam_screen.dart';
import 'profile_page.dart';
import 'video_player_view.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool hasShowPaymentDiolog = false;

  final VideoController videoController = Get.put(VideoController());
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;
  int selectedIndex = 0;

  late RazorpayService razorpayService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoController.fetchVideos();
    });
    razorpayService = RazorpayService(
      onPaymentSuccessCallback: (){
        showGiftBoxDialog();
      }
    );

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   bool isOpened = await SessionManager.isGiftOpened();
    //
    //   if (!isOpened) {
    //     showGiftBoxDialog();
    //   }
    // });
  }


  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  List images = [
    "assets/img1.png",
    "assets/img2.png",
    "assets/img3.png",
    "assets/img4.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔹 NORMAL APP BAR
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F0524),
                Color(0xFF4B0082),
                Color(0xFF8A2BE2),
                Color(0xFFDA70D6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              /// ⭐ Small stars
              ...List.generate(
                25,
                (index) => Positioned(
                  top: (index * 7.0) % 80,
                  left: (index * 15.0) % 400,
                  child: Container(
                    height: 2,
                    width: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              /// 🌟 Glow star
              Positioned(
                right: 40,
                top: 20,
                child: Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.white),

        /// 🔹 Thirukural Title
        title: Row(
          children: [
            Expanded(
              child: Text(
                "அற்றார் அளித்தல் அரணால் அஃதிலார்\nபெற்றார் அளித்தல் இலர்",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            SizedBox(
              height: 40.h,
              width: 40.w,
              child: Image.asset("assets/ALogo/logo.png", fit: BoxFit.contain),
            ),
            SizedBox(width: 3.w),
          ],
        ),

        /// 🔹 Profile
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F0524),
                Color(0xFF4B0082),
                Color(0xFF8A2BE2),
                Color(0xFFDA70D6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.menu, color: Colors.white, size: 30),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const Text(
                      "Dashboard Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔥 MENU ITEMS
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    /// 🔹 PROFILE
                    _buildDrawerItem(
                      title: "Profile",
                      icon: Icons.person,
                      index: 0,
                      onTap: () {
                        setState(() => selectedIndex = 0);
                        Get.back();
                        Get.to(() => ProfileScreen());
                      },
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 JODHIDAM

                    // _buildDrawerItem(
                    //   title: "Jodhidam",
                    //   icon: Icons.auto_awesome,
                    //   index: 1,
                    //   onTap: () {
                    //     setState(() => selectedIndex = 1);
                    //     Get.back();
                    //     // Get.to(() => JodhidamScreen());
                    //     Get.to(() => BirthDetailsFormScreen());
                    //   },
                    // ),
                    
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Videos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildDrawerVideoList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔹 BODY SECTION
      body: Stack(
        children: [
          Obx(() {
            debugPrint(
              "UI => Free:${videoController.freeVideos.length}"
                  " Entry:${videoController.entryVideos.length}"
                  " Advance:${videoController.advanceVideos.length}",
            );

            return Container();
          }),
          /// 🌌 Deep Space Gradient
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4FAF2A),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Color(0xFF1F5F12),
              //     Color(0xFF4FAF2A),
              //     Color(0xFF7CCF35),
              //   ],
              // ),
            ),
          ),

          /// 🌙 Moon Glow
          Positioned(
            top: 60,
            right: 40,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          ...List.generate(
            40,
            (index) => Positioned(
              top: (index * 37) % 700,
              left: (index * 53) % 350,
              child: Container(
                height: 2,
                width: 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.6),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 MAIN CONTENT
          Obx(() {
            return RefreshIndicator(
              color: const Color(0xFF7CCF35),
              onRefresh: videoController.fetchVideos,
              child: videoController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "விதியின் மறைந்த உலகம்",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  "பழமையான ஜோதிட ரகசியங்கள் இப்போது உங்கள் கையில்",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10.h),

                          /// Carousel
                          CarouselSlider.builder(
                            carouselController: _carouselController,
                            itemCount: images.length,
                            options: CarouselOptions(
                              height: 180,
                              autoPlay: true,
                              viewportFraction: 0.9,
                              enlargeCenterPage: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: Image.asset(images[index]).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 6.h),

                          Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: 3,
                              effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// VIDEO SECTION
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Text(
                                    "5000 ஆண்டுகளாக மறைந்திருந்த ஜோதிட \nரகசியங்கள் இங்கே…",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              if (!videoController.hasPaidBasic.value &&
                                  !videoController.hasPaidAdvance.value)
                                buildFreeTrialVideos(),

                              if (videoController.hasPaidBasic.value &&
                                  !videoController.hasPaidAdvance.value)
                                buildBasicVideos(),

                              if (videoController.hasPaidAdvance.value)
                                buildAdvanceVideos(),


                              // SizedBox(height: 2.h),
                              // if (videoController.hasPaidBasic.value)
                              // Center(
                              //   child: Text(
                              //     "ஜோதிட அறிவின் உலகிற்கு வரவேற்கிறோம்",
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 12.sp,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              //
                              // SizedBox(height: 2.h),
                              //
                              // if (videoController.hasPaidBasic.value)
                              //   buildBasicVideos(),
                              // SizedBox(height: 2.h),
                              // if (videoController.hasPaidAdvance.value)
                              // Center(
                              //   child: Text(
                              //     "ஜோதிட அறிவின் உலகிற்கு வரவேற்கிறோம்",
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 12.sp,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: 2.h),
                              // if (videoController.hasPaidAdvance.value)
                              //   buildAdvanceVideos(),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
  Widget _buildDrawerVideoList() {
    List videosToShow = [];

    if (videoController.hasPaidAdvance.value) {
      videosToShow = [
        ...videoController.freeVideos,
        ...videoController.entryVideos,
      ];
    } else if (videoController.hasPaidBasic.value) {
      videosToShow = videoController.freeVideos;
    } else {
      return const SizedBox();
    }

    return Column(
      children: videosToShow.map<Widget>((video) {
        return GestureDetector(
          onTap: () {
            Get.to(
                  () => VideoPlayerView(
                urls: videosToShow
                    .map((e) => e.videoUrl)
                    .toList()
                    .cast<String>(),
                startIndex: videosToShow.indexOf(video),
              ),
            );
          },
          child: buildVideoCard(isFree: true,videoUrl: video.videoUrl), // 🔥 reuse your UI
        );
      }).toList(),
    );
  }

  Widget buildFreeTrialVideos() {
  return Column(
    children: videoController.freeVideos.asMap().entries.map((entry) {

      int index = entry.key;
      final video = entry.value;

      return GestureDetector(
        onTap: () {
          Get.to(
            () => VideoPlayerView(
              urls: videoController.freeVideos
                  .map((e) => e.videoUrl)
                  .toList(),
              startIndex: index,
              onCompleted: () {
                if (!videoController.hasPaidBasic.value) {
                  showPaymentDialog();
                } else if (!videoController.hasPaidAdvance.value) {
                  showAdvancePaymentDialog();
                }
              },
            ),
          );
        },

        child: buildVideoCard(
          isFree: true,
          videoUrl: video.videoUrl,
        ),
      );
    }).toList(),
  );
}

  Widget buildBasicVideos() {
  return Column(
    children: videoController.entryVideos.asMap().entries.map((entry) {

      int index = entry.key;
      final video = entry.value;

      return GestureDetector(
        onTap: () {
          Get.to(
            () => VideoPlayerView(
              urls: videoController.entryVideos
                  .map((e) => e.videoUrl)
                  .toList(),
              startIndex: index,
              onCompleted: () {
                if (!videoController.hasPaidAdvance.value) {
                  showAdvancePaymentDialog();
                }
              },
            ),
          );
        },

        child: buildVideoCard(
          isFree: false,
          videoUrl: video.videoUrl,
        ),
      );
    }).toList(),
  );
}

  Widget buildAdvanceVideos() {
    return Column(
      children: videoController.advanceVideos.map((video) {
        return GestureDetector(
          onTap: () {
            Get.to(
              () => VideoPlayerView(
                urls: videoController.advanceVideos
                    .map((e) => e.videoUrl)
                    .toList(),
                startIndex: videoController.advanceVideos.indexOf(video),
                onCompleted: () {
                  showReferralDialog();
                },
              ),
            );
          },
          child: buildVideoCard(isFree: false,videoUrl: video.videoUrl),
        );
      }).toList(),
    );
  }

  DateTime entryOfferStartTime = DateTime.now();
  DateTime advanceOfferStartTime = DateTime.now();

  int getEntryPrice() {
    final now = DateTime.now();
    final difference = now.difference(entryOfferStartTime).inMinutes;

    if (difference <= 60) {
      return 349;
    } else {
      return 349;
    }
  }

  int getAdvancePrice() {
    final now = DateTime.now();
    final difference = now.difference(advanceOfferStartTime).inMinutes;

    if (difference <= 60) {
      return 999;
    } else {
      return 999;
    }
  }

  void showPaymentDialog() {
    int price = getEntryPrice();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F0524), Color(0xFF4B0082), Color(0xFF8A2BE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),

          child: Stack(
            children: [
              /// ⭐ Galaxy Stars
              ...List.generate(
                25,
                (index) => Positioned(
                  top: (index * 13.0) % 250,
                  left: (index * 19.0) % 320,
                  child: Container(
                    height: 2,
                    width: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              /// 🔹 MAIN CONTENT
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🌟 Premium Icon Glow
                  Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/ALogo/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// TITLE
                  Text(
                    "👉 ஜோதிடப் பாடங்களை திறக்கவும்",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Text(
                  //   "🔮 5000 ஆண்டு பழமையான ஜோதிட ரகசியங்கள்.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  // ),
                  const SizedBox(height: 20),

                  /// FEATURES
                  _buildFeatureRow("🔮 5000 ஆண்டு பழமையான ஜோதிட ரகசியங்கள்."),
                  _buildFeatureRow(
                    "✨ எடுத்துக்காட்டுகளுடன் கற்றுக்கொள்ளுங்கள்",
                  ),
                  _buildFeatureRow("📚 மனப்பாடம் இல்லாமல் கற்கும் முறை"),
                  _buildFeatureRow("👉 உயர் தர (HD) வீடியோத் தரம்"),

                  const SizedBox(height: 25),

                  /// PRICE
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// PAY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        razorpayService.openCheckout("Entry", amount: price);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF8A2BE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "🎥 இப்போது பாடங்களைத் திறக்கவும்",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CANCEL
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "👉 திரும்பவும்",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAdvancePaymentDialog() {
    int price = getAdvancePrice();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F0524), Color(0xFF4B0082), Color(0xFF8A2BE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),

          child: Stack(
            children: [
              /// ⭐ Stars Background
              ...List.generate(
                25,
                (index) => Positioned(
                  top: (index * 13.0) % 250,
                  left: (index * 19.0) % 320,
                  child: Container(
                    height: 2,
                    width: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              /// 🔥 Main Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🌟 Icon Glow
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2BE2), Color(0xFFDA70D6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.6),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TITLE
                  const Text(
                    "Unlock Advanced Course 🚀",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Master astrology with deep advanced secrets.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 20),

                  /// FEATURES
                  _buildFeatureRow("🔮 Advanced Astrology Lessons"),
                  _buildFeatureRow("✨ Premium Expert Guidance"),
                  _buildFeatureRow("📚 Exclusive Hidden Knowledge"),
                  _buildFeatureRow("🎯 Lifetime Access"),

                  const SizedBox(height: 25),

                  /// PRICE
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// PAY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        razorpayService.openCheckout("Advance", amount: price);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF8A2BE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "🚀 Unlock Advanced Now",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CANCEL
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Maybe Later",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showReferralDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Invite Friends"),
        content: Text("Refer your friends and earn rewards"),
        actions: [
          TextButton(
            onPressed: () {
              // share referral
            },
            child: Text("Share Referral"),
          ),
        ],
      ),
    );
  }

  void showGiftBoxDialog() async{
    bool isOpened =await SessionManager.isGiftOpened();
    if (isOpened) return;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F0524), Color(0xFF4B0082), Color(0xFF8A2BE2)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.card_giftcard, size: 80, color: Colors.white),

              const SizedBox(height: 10),

              const Text(
                "🎉 Special Gift!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Fill Google Form & get reward 🎁",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await SessionManager.setGiftOpened();

                  openGoogleForm();

                  Get.back();
                },
                child: const Text("Open Gift 🎁"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6A5AE0), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required int index,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? const LinearGradient(colors: [Colors.white, Colors.white70])
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.08),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isSelected ? Colors.black : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoCard({required bool isFree,required String videoUrl,}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 🔹 Background Image
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: VideoThumbnailWidget(videoUrl: videoUrl)
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // 🔹 Video Title + Subtitle
            // Positioned(
            //   bottom: 20,
            //   left: 20,
            //   right: 80,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         isFree ? "Free Introduction Class" : "Entry Level Lesson",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14.sp,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            if (isFree)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Trial Videos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

            // 🔹 Play Button (Premium Style)
            Positioned(
              bottom: 15,
              left: 20,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.6),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoThumbnailWidget> createState() =>
      _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState
    extends State<VideoThumbnailWidget> {

  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  Future<void> generateThumbnail() async {
    final path = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 500,
      quality: 75,
    );

    if (mounted) {
      setState(() {
        thumbnailPath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (thumbnailPath == null) {
      return Container(
        color: Colors.black12,
        child: Center(
          child: Lottie.asset(
            height: 100.h,
            width: 100.w,
            fit: BoxFit.fill,
            "assets/loding_animation.json"
          ),
        ),
      );
    }

    return Image.file(
      File(thumbnailPath!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
