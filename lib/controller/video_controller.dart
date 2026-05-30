import 'package:get/get.dart';
import 'package:flutter/foundation.dart';


import '../api_services/video_api.dart';
import '../model/customer_video_model.dart';
import '../model/video_model.dart';
import '../routes/SessionManger.dart';

class VideoController extends GetxController {

  var isLoading = false.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  var hasPaidBasic = false.obs;
  var hasPaidAdvance = false.obs;
  var hasPaid = false.obs;
  var freeVideos = <VideoItem>[].obs;
  var entryVideos = <VideoItem>[].obs;
  var advanceVideos = <VideoItem>[].obs;
  // var CustomerfreeVideos = <CustomerVideoItem>[].obs;
  // var CustomerentryVideos = <CustomerVideoItem>[].obs;
  // var CustomeradvanceVideos = <CustomerVideoItem>[].obs;
  bool hasShownLastFiveSecDialog = false;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
    checkPaymentStatus();
  }

  /// ================= FETCH VIDEOS =================
  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;

      final response = await VideoApiService.fetchCVideos();

      debugPrint("========== VIDEO RESPONSE ==========");
      debugPrint("success => ${response.success}");
      debugPrint("message => ${response.message}");
      debugPrint("hasEntry => ${response.hasEntry}");
      debugPrint("hasAdvance => ${response.hasAdvance}");

      debugPrint("free count => ${response.free.videos.length}");
      debugPrint("entry count => ${response.entry.videos.length}");
      debugPrint("advance count => ${response.advance.videos.length}");

      if (response.free.videos.isNotEmpty) {
        debugPrint("first free video => ${response.free.videos.first.videoUrl}");
      }

      if (response.entry.videos.isNotEmpty) {
        debugPrint("first entry video => ${response.entry.videos.first.videoUrl}");
      }

      if (response.advance.videos.isNotEmpty) {
        debugPrint("first advance video => ${response.advance.videos.first.videoUrl}");
      }

      if (response.success) {

        freeVideos.assignAll(
          response.free.videos.map((e) => VideoItem(
            id: e.id,
            videoUrl: e.videoUrl,
          )).toList(),
        );

        entryVideos.assignAll(
          response.entry.videos.map((e) => VideoItem(
            id: e.id,
            videoUrl: e.videoUrl,
          )).toList(),
        );

        advanceVideos.assignAll(
          response.advance.videos.map((e) => VideoItem(
            id: e.id,
            videoUrl: e.videoUrl,
          )).toList(),
        );

        debugPrint("freeVideos => ${freeVideos.length}");
        debugPrint("entryVideos => ${entryVideos.length}");
        debugPrint("advanceVideos => ${advanceVideos.length}");
      }

    } catch (e, s) {
      debugPrint("ERROR => $e");
      debugPrint("$s");
    } finally {
      isLoading.value = false;
    }
  }

  void unlockPremiumVideos() {

    hasPaid.value = true;

    Get.snackbar(
      "Payment Success",
      "Premium Videos Unlocked",
    );

  }

  void unlockBasicVideos() {
    hasPaid.value = true;
    hasPaidBasic.value = true;

    Get.snackbar(
      "Payment Success",
      "Basic Videos Unlocked",
    );
  }

  void unlockAdvanceVideos() {
    hasPaid.value = true;
    hasPaidBasic.value = true;
    hasPaidAdvance.value = true;

    Get.snackbar(
      "Payment Success",
      "Advance Videos Unlocked",
    );
  }
  /// ================= UPLOAD VIDEO =================
  Future<void> uploadVideo({
    required String videoUrl,
    required String type,
  }) async {

    debugPrint("========== VIDEO CONTROLLER UPLOAD START ==========");
    debugPrint("Video URL: $videoUrl");
    debugPrint("Type: $type");

    try {
      isUploading.value = true;

      final response = await VideoApiService.uploadVideoToBackend(
        videoUrl: videoUrl,
        type: type,
      );

      if (response is Map && response["success"] == true) {

        Get.snackbar("Success", response["message"]);

        /// 🔥 IMPORTANT → Refresh videos after upload
        await fetchVideos();

      } else {
        Get.snackbar("Failed", response["message"] ?? "Upload Failed");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploading.value = false;
      debugPrint("========== VIDEO CONTROLLER UPLOAD END ==========");
    }
  }

  /// ================= ADMIN FETCH =================
  Future<void> adminVideos(String userId) async {
    try {
      isLoading.value = true;

      final response = await VideoApiService.fetchVideos(userId);

      if (response.success) {
        freeVideos.assignAll(
            response.type.expand((e) => e.videos).toList());

        entryVideos.assignAll(
            response.type2.expand((e) => e.videos).toList());

        advanceVideos.assignAll(
            response.type3.expand((e) => e.videos).toList());
      }

    } catch (e) {
      debugPrint("Admin Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> checkPaymentStatus() async {
    try {
      String? userId = await SessionManager.getUserId();

      if (userId == null) return;

      final response = await VideoApiService.getPaymentStatus(
        int.parse(userId),
      );

      if (response['success'] == true) {

        if (response['hasEntry'] == true) {
          hasPaid.value = true;
          hasPaidBasic.value = true;
        }

        if (response['hasAdvance'] == true) {
          hasPaid.value = true;
          hasPaidBasic.value = true;
          hasPaidAdvance.value = true;
        }
      }

    } catch (e) {
      debugPrint("Payment Status Error: $e");
    }
  }
}